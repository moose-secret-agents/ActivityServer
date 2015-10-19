class AddUserReferenceToTrainingSession < ActiveRecord::Migration
  def change
    add_reference :training_sessions, :user, index: true, foreign_key: true
  end
end
