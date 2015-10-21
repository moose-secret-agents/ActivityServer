class TrainingSession < ActiveRecord::Base
  has_many :data_points

  def update_stats

  end
end
