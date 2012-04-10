class Fachschaft < ActiveRecord::Base
  attr_accessible :name, :mail, :url, :address

  validates :name, :mail,  :presence => true
  validates :name, :mail,  :uniqueness => true

  validates :address,  :presence => true

  validates_format_of :mail, :with => MAIL_REGEX

  has_and_belongs_to_many :users
  has_many :votes

  # finds all motions that are still open for voting (and the FS result
  # if available). Format is [{:motion => …, :vote => …}, …]
  def get_votable_motions
    d = []
    Motion.find_all_votable.each do |m|
      v = Vote.where({ :motion_id => m, :fachschaft_id => self }).first
      d << { :motion => m, :vote => v }
    end
    d
  end
end
