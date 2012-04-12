class ChangeDataTypeForMotionId < ActiveRecord::Migration
  def self.up
    change_table :attachments do |t|
      t.change :motion_id, :binary
    end

    change_table :comments do |t|
      t.change :motion_id, :binary
    end
  end

  def self.down
    change_table :attachments do |t|
      t.change :motion_id, :integer
    end

    change_table :comments do |t|
      t.change :motion_id, :integer
    end
  end
end
