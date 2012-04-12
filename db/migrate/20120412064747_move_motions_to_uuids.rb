class MoveMotionsToUuids < ActiveRecord::Migration
  def up
    add_column :motions, :uuid, :string, :limit => 36, :primary => true
    remove_column :motions, :id
  end

  def down
    remove_column :motions, :uuid
  end
end
