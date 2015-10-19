class CreateDataPoints < ActiveRecord::Migration
  def change
    create_table :data_points do |t|
      t.timestamps :recorded_at,
      t.decimal, :long
      t.decimal :lat
      t.string :activity
      t.belongs_to :training_session, index:true
      t.timestamps null: false
    end
  end
end
