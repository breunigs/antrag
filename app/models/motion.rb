# encoding: utf-8

class Motion < ActiveRecord::Base
  include Extensions::UUID

  # only make the attributes mass-writable that may be entered by the
  # applicant.
  attr_accessible :kind, :title, :text, :contact_mail, :contact_name
  attr_accessible :contact_fon, :fin_expected_amount, :referat_id

  # these need to be present
  validates :kind, :title, :text, :contact_mail, :uuid, :dynamic_fields, :presence => true

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

  def is_public?
    !publication.blank?
  end

  def finanz?
    kind == "finanz"
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
    subblock ? @dynamic_unmarshaled[kind.gsub(/[^a-z0-9]+/i, "_")] : @dynamic_unmarshaled
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
      #eval("val = val#{f[:name_append]}") if f[:name_append]
      errors.add(:base, "#{f[:name]} darf nicht leer sein.") if !f[:optional] && [:string, :integer, :float].include?(f[:type]) && val.blank?
      errors.add(:base, "#{f[:name]} ist kein gültiges Datum.") if :date ==f[:type] && !(val.is_a?(Date))
      errors.add(:base, "#{f[:name]} ist keine ganze Zahl.") if :integer ==f[:type] && val.to_i.to_s != val
      errors.add(:base, "#{f[:name]} ist keine Dezimalzahl.") if :float ==f[:type] && !(val.to_f.to_s == val || val.to_i.to_s == val)

      if :select == f[:type]
        opt = f[:values].map { |v| v.is_a?(String) ? v : v[:name] }
        errors.add(:base, "#{f[:name]} hat eine ungültige Auswahl.") unless opt.include?(val) || (val.blank? && f[:optional])
      end
    end
  end
end
