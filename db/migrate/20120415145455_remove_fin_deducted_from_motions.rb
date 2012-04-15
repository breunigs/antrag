class RemoveFinDeductedFromMotions < ActiveRecord::Migration
  def up
    remove_column :motions, :fin_deducted
  end

  def down
    add_colum :motions, :fin_deducted, :boolean
  end
end
