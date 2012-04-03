class FachschaftsUsers < ActiveRecord::Migration
  def self.up
    create_table :fachschafts_users, :id => false do |t|
      t.integer :user_id
      t.integer :fachschaft_id
    end
  end
                         
  def self.down
    drop_table :fachschafts_users
  end
end
