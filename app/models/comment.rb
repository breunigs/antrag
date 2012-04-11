# encoding: utf-8

class Comment < ActiveRecord::Base
  # only allow comment to be set via POST data, all other values should
  # come from within rails.
  attr_accessible :comment

  validates :motion_id, :comment, :ip, :presence => true

  belongs_to :motion
  belongs_to :user

  def anonymous?
    user_id.blank? || user.nil?
  end

  def get_name
    anonymous? ? "Unbekannt (#{ip})" : user.name
  end
end
