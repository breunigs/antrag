class CreateMotions < ActiveRecord::Migration
  def change
    create_table :motions do |t|
      t.string :type
      t.string :title
      t.text :text
      t.boolean :is_top
      t.string :contact_mail
      t.string :contact_name
      t.string :contact_fon
      t.string :indent
      t.date :publication
      t.string :status
      t.float :fin_expected_amount
      t.float :fin_charged_amount
      t.boolean :fin_deducted
      t.boolean :fin_granted

      t.timestamps
    end
  end
end
