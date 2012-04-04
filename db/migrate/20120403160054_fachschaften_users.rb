class FachschaftenUsers < ActiveRecord::Migration
  def self.up
    create_table :fachschaften_users, :id => false do |t|
      t.integer :user_id
      t.integer :fachschaft_id
    end
  end

  def self.down
    drop_table :fachschaften_users
  end
end
