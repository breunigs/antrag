class Referat < ActiveRecord::Base
  attr_accessible :name, :mail

  validates :name, :mail,  :presence => true
  validates :name,         :uniqueness => true

  validates_format_of :mail, :with => MAIL_REGEX

  has_and_belongs_to_many :users

  has_many :motions
end
