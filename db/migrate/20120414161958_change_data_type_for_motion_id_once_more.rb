class ChangeDataTypeForMotionIdOnceMore < ActiveRecord::Migration
  def self.up
    change_table :motions do |t|
      t.change :uuid, :string
    end

    change_table :attachments do |t|
      t.change :motion_id, :string
    end

    change_table :comments do |t|
      t.change :motion_id, :string
    end
  end

  def self.down
    change_table :attachments do |t|
      t.change :motion_id, :binary
    end

    change_table :comments do |t|
      t.change :motion_id, :binary
    end

    change_table :motions do |t|
      t.change :uuid, :binary
    end
  end
end
