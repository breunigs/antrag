class DropIsTopFromMotions < ActiveRecord::Migration
  def up
    remove_column :motions, :is_top
  end

  def down
    add_column :motions, :is_top, :boolean
  end
end
