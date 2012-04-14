class AddColumnsToMotions < ActiveRecord::Migration
  def change
    add_column :motions, :referat_id, :integer

    add_column :motions, :dynamic_fields, :text

  end
end
