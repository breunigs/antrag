class ReferateUsers < ActiveRecord::Migration
  def self.up
    create_table :referate_users, :id => false do |t|
      t.integer :user_id
      t.integer :referat_id
    end
  end

  def self.down
    drop_table :referate_users
  end
end
