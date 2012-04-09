class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :id
      t.integer :user_id
      t.integer :motion_id
      t.text :comment

      t.timestamps
    end
  end
end
