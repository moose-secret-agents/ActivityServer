class AddWorkoutStatsToTrainingSession < ActiveRecord::Migration
  def change
    add_column :training_sessions, :elevation_gain, :decimal
    add_column :training_sessions, :distance, :decimal
    add_column :training_sessions, :duration, :integer
    add_column :training_sessions, :activity, :string
    add_column :training_sessions, :avg_speed, :decimal
    add_column :training_sessions, :current_speed, :decimal
    add_column :training_sessions, :training_points, :integer


  end
end
