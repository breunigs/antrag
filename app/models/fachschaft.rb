class Fachschaft < ActiveRecord::Base
  attr_accessible :name, :mail, :url, :address

  validates :name, :mail,  :presence => true
  validates :name, :mail,  :uniqueness => true

  validates_format_of :mail, :with => MAIL_REGEX

  has_and_belongs_to_many :users
end
