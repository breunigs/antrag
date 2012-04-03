class AddGroupsToUser < ActiveRecord::Migration
  def change
    add_column :users, :groups, :string

  end
end
