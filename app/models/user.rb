class User < ActiveRecord::Base
  attr_accessible :name

  validates :name, :uid, :provider, :presence => true
  validates :name, :uid,            :uniqueness => true

  has_and_belongs_to_many :fachschafts



  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.name = auth["info"]["name"]
    end
  end
end
