class AddIpColumnToAttachments < ActiveRecord::Migration
  def change
    add_column :attachments, :ip, :string

  end
end
