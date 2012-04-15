class AddTopColumnToMotions < ActiveRecord::Migration
  def change
    add_column :motions, :top, :string
  end
end
