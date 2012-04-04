class CreateReferate < ActiveRecord::Migration
  def change
    create_table :referate do |t|
      t.string :name
      t.string :mail

      t.timestamps
    end
  end
end
