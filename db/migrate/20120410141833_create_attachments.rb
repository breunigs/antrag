class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.has_attached_file :file
      t.integer :motion_id
      t.timestamps
    end
  end
end
