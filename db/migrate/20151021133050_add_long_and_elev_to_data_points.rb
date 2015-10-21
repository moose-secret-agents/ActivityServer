class AddLongAndElevToDataPoints < ActiveRecord::Migration
  def change
    add_column :data_points, :long, :decimal
    add_column :data_points, :elevation, :decimal
  end
end
