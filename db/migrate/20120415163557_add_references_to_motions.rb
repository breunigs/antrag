class AddReferencesToMotions < ActiveRecord::Migration
  def change
    add_column :motions, :references, :text

  end
end
