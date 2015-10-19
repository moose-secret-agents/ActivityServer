class CreateTrainingSessions < ActiveRecord::Migration
  def change
    create_table :training_sessions do |t|

      t.timestamps null: false
    end
  end
end
