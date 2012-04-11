class AddIpColumnToComments < ActiveRecord::Migration
  def change
    add_column :comments, :ip, :string

  end
end
