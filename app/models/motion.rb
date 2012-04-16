# encoding: utf-8

class Motion < ActiveRecord::Base
  include Extensions::UUID

  # only make the attributes mass-writable that may be entered by the
  # applicant.
  attr_accessible :kind, :title, :text, :contact_mail, :contact_name
  attr_accessible :contact_fon, :referat_id

  # these need to be present
  validates :kind, :title, :text, :contact_mail, :uuid, :dynamic_fields, :status, :presence => true

  # if present, please be numbers
  validates :fin_expected_amount, :fin_charged_amount, :numericality => true, :allow_blank => true

  # validate the mail address is valid
  validates_format_of :contact_mail, :with => MAIL_REGEX

  # limit kinds of motions.
  validates_format_of :kind, :with => /^[\sa-z\/]+$/i
  validate :kind_exists

  # validate all those dynamic fields
  validate :dynamic_data_is_correct

  has_many :votes
  has_many :comments, :order => 'created_at ASC'
  has_many :attachments, :order => 'file_updated_at ASC'

  belongs_to :referat

  # Constants for status handling
  STATUS_NEW = "neu"
  STATUS_DENIED = "abgelehnt"
  STATUS_GRANTED = "bewilligt"
  STATUS_FORMS_ARRIVED = "Formulare in der FSK eingegangen"
  STATUS_ZUV_GRANTED = "durch die ZUV genehmigt"
  STATUS_ZUV_DENIED = "durch die ZUV abgelehnt"
  STATUS_BILLS_ARRIVED = "Abrechnungen eingegangen"
  STATUS_DEDUCTED = "Gebucht"
  STATUS_COMPLETED = "Abgeschlossen"
  TOP_NONE = "nirgens"
  TOP_FSK = "FSK"
  TOP_REFKONF = "RefKonf"
  TOP_BOTH = "FSK oder RefKonf"


  def is_public?
    !publication.blank?
  end

  def finanz?
    kind =~ /^Finanzantrag\//
  end

  def referat_may_accept?
    finanz? && fin_expected_amount <= MAX_REFERAT_FINANZ_BUDGET
  end

  def is_finished?
    [STATUS_DENIED, STATUS_COMPLETED, STATUS_ZUV_DENIED].include?(status)
  end

  # derives the top state from the referat status and amount of money
  # requested.
  def get_top_state
    return Motion::TOP_NONE if status != STATUS_NEW
    if referat_may_accept?
      referat.nil? ? Motion::TOP_BOTH : Motion::TOP_NONE
    else
      Motion::TOP_FSK
    end
  end

  # Returns the name/mail of the submitter in mail header friendly
  # format
  def submitter
    contact_name.blank? ? contact_mail : "#{contact_name} <#{contact_mail}>"
  end

  # finds all motions that are still open for voting
  def self.find_all_votable
    Motion.where({:publication => nil})
  end

  # returns the form data as stored in initializers/constants.rb. May
  # return nil if there is no result.
  def get_form
    ALL_MOTIONS.detect { |m| m[:ident] == kind }
  end

  def get_form_fields
    get_form[:groups].map { |g| g[:fields] }.flatten
  end

  # unmarshals the dynamic_fields attribute and returns the object for
  # easy access. Returns only the sub-block for the current kind of
  # motion, unless specified otherwise.
  def dynamic(subblock = true)
    @dynamic_unmarshaled ||=Marshal.load(Base64.decode64(dynamic_fields))
    subblock ? @dynamic_unmarshaled[kind.field_cleanup] : @dynamic_unmarshaled
  end

  def bahncard_to_float(index)
    case dynamic["Bahncard"][index]
      when "BahnCard 25" then 0.75
      when "BahnCard 50" then 0.5
      when "keine"       then 1.0
      else raise "BahnCard Typ unbekannt: #{bc}"
    end
  end

  def calc_fin_expected_amount
    # collect all fields that make up the fin_exp_amount
    exp = 9999.99
    d = dynamic
    case kind
      when "Finanzantrag/Orientierungsveranstaltung"
        exp = d["beantragter Zuschuss".field_cleanup].to_f_magic
      when "Finanzantrag/Reisekostenantrag"
        case d["Verkehrsmittel".field_cleanup]
          when "Bahn"
            exp = 0
            bahn = d["Kosten Bahnfahrt".field_cleanup].to_f_magic
            d["Name"].each do |id, name|
              exp += bahn * bahncard_to_float(id) unless name.blank?
            end
          when "Auto"
            privat = d["Automiete".field_cleanup].to_f_magic == 0
            if privat
              exp = d["Fahrtweg in km".field_cleanup].to_f_magic * KILOMETER_PAUSCHALE
            else
              exp = d["Treibstoffkosten".field_cleanup].to_f_magic + d["Automiete".field_cleanup].to_f_magic
            end
          when "Sonstiges"
            exp = d["Kosten insgesamt".field_cleanup].to_f_magic
          else raise("Invalid Verkehrsmittel selection.")
        end
      when "Finanzantrag/Vortrag (Honorar)"
        exp = d["Fahrtkosten".field_cleanup].to_f_magic + d["Honorarhöhe".field_cleanup].to_f_magic
      when "Finanzantrag/Sonstiges"
        exp = d["Kosten".field_cleanup].to_f_magic
      when "Finanzantrag/Beschaffungsantrag"
        exp = d["Kosten".field_cleanup].to_f_magic
      else raise("Unimplemented calc_fix_expected_amount for #{kind}.")
    end
    exp
  end

  # validates the selected kind actually exists
  def kind_exists
    if get_form.nil?
      errors.add(:base, "Der ausgewählte Antragstyp existiert nicht. Dies deutet auf einen Programmierfehler hin, da Du den Typ gar nicht manuell bestimmen kannst.")
      return
    end
  end

  # validates all dynamic fields are filled in correctly
  def dynamic_data_is_correct
    d = dynamic
    form = get_form
    # data not available. Will be caught by kind_exists.
    return if d.nil? || form.nil?

    get_form_fields.each do |f|
      val =  d[f[:name].field_cleanup]
      val = val[f[:index].to_s] if f[:index]
      errors.add(:base, "#{f[:name]} darf nicht leer sein.") if !f[:optional] && [:string, :integer, :float].include?(f[:type]) && val.blank?
      errors.add(:base, "#{f[:name]} ist kein gültiges Datum.") if :date ==f[:type] && !(val.is_a?(Date))
      errors.add(:base, "#{f[:name]} ist keine ganze Zahl.") if :integer ==f[:type] && !val.valid_integer?
      errors.add(:base, "#{f[:name]} ist keine Dezimalzahl.") if [:currency, :float].include?(f[:type]) && !val.valid_float?

      if :select == f[:type]
        opt = f[:values].map { |v| v.is_a?(String) ? v : v[:name] }
        errors.add(:base, "#{f[:name]} hat eine ungültige Auswahl.") unless opt.include?(val) || (val.blank? && f[:optional])
      end
    end
  end
end
