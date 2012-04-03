class CreateFachschafts < ActiveRecord::Migration
  def change
    create_table :fachschafts do |t|
      t.string :name
      t.string :mail
      t.string :url
      t.string :address

      t.timestamps
    end
  end
end
