class Comment < ActiveRecord::Base
  attr_accessible :user_id, :motion_id, :comment

  belongs_to :motion
  belongs_to :user
end
