class FixMotionIdentColumnName < ActiveRecord::Migration
  def change
      rename_column :motions, :indent, :ident
  end      
end
