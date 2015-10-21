class AddActCertaintyToDataPoint < ActiveRecord::Migration
  def change
    add_column :data_points, :activity_certainty, :integer
  end
end
