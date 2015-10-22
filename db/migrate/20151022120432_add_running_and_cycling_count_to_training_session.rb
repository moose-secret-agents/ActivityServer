class AddRunningAndCyclingCountToTrainingSession < ActiveRecord::Migration
  def change
    add_column :training_sessions, :cycling_count, :integer
    add_column :training_sessions, :running_count, :integer
  end
end
