class ChangeTrainingSessionDurationToDecimal < ActiveRecord::Migration
  def change
    change_column :training_sessions, :duration, :decimal
  end
end
