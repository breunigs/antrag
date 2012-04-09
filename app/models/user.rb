class User < ActiveRecord::Base
  attr_accessible :groups, :fachschaft_ids, :referat_ids

  validates :name, :uid, :provider, :presence => true
  validates :name, :uid,            :uniqueness => true

  has_and_belongs_to_many :fachschaften
  has_and_belongs_to_many :referate

  has_many :comments

  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.name = auth["info"]["name"]
      user.groups = ""
    end
  end

  # Determines the root status of the given user.
  def self.is_root?(user)
    return false if user.nil? || user.groups.nil?
    user.groups.split(" ").include?("root")
  end

  # Determines the root status of this user.
  def is_root?
    User.is_root?(self)
  end

  # Methods regarding the “current_user” are located in app/helpers/
  # UserHelper.rb
end
