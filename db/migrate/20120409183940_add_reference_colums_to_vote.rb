class AddReferenceColumsToVote < ActiveRecord::Migration
  def change
    add_column :votes, :motion_id, :integer
    add_column :votes, :fachschaft_id, :integer
  end
end
