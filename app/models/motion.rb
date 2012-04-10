class Motion < ActiveRecord::Base
  # only make the attributes mass-writable that may be entered by the
  # applicant.
  attr_accessible :kind, :title, :text, :contact_mail, :contact_name
  attr_accessible :contact_fon, :fin_expected_amount

  # these need to be present
  validates :kind, :title, :text, :contact_mail, :presence => true

  # if present, please be numbers
  validates :fin_expected_amount, :fin_charged_amount, :numericality => true, :allow_blank => true

  # validate the mail address is valid
  validates_format_of :contact_mail, :with => MAIL_REGEX

  # limit kinds of motions. FIXME FIXME FIXME
  validates_format_of :kind, :with => /^finanz|position|b$/

  has_many :votes
  has_many :comments, :order => 'created_at ASC'
  has_many :attachments, :order => 'file_updated_at ASC'

  def is_public?
    !publication.blank?
  end

  def finanz?
    kind == "finanz"
  end

  def kind_printable
    case kind
      when "finanz" then "Finanzantrag"
      when "position" then "Positionierungsantrag"
      when "b" then "FIXME"
      else raise "Invalid format for motion#kind"
    end
  end

  # finds all motions that are still open for voting
  def self.find_all_votable
    Motion.where({:publication => nil})
  end
end
