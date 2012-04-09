class FixMotionTypeColumnName < ActiveRecord::Migration
  def change
     rename_column :motions, :type, :kind
  end
end
