class MoveMotionsToUuids < ActiveRecord::Migration
  def up
    add_column :motions, :uuid, :binary, :primary => true
    remove_column :motions, :id
  end

  def down
    add_column :motions, :id, :integer, :primary => true
    remove_column :motions, :uuid
  end
end
