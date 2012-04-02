class Fachschaft < ActiveRecord::Base
  attr_accessible :name, :mail, :url, :address

  validates :name, :mail,  :presence => true
  validates :name, :mail,  :uniqueness => true

  has_and_belongs_to_many :users
end
