class RemoveFinGrantedFromMotions < ActiveRecord::Migration
  def up
    remove_column :motions, :fin_granted
  end

  def down
    add_colum :motions, :fin_granted, :boolean
  end
end
