# encoding: utf-8

class Comment < ActiveRecord::Base
  attr_accessible :user_id, :motion_id, :comment

  validates :motion_id, :comment, :presence => true

  belongs_to :motion
  belongs_to :user

  def anonymous?
    user_id.blank? || user.nil?
  end

  def get_name
    anonymous? ? "Unbekannt" : user.name
  end
end
