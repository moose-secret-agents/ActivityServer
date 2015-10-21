class TrainingSession < ActiveRecord::Base
  has_many :data_points
  EARTH_CIRCUMFERENCE = 6371000 * 2 * Math::PI#radius of earth in meters
  def add_point (long, lat, elevation, activity, activity_certainty)
    sorted_points = data_points.sort_by {|dp| dp.created_at}
    data_point = data_points.new(long: long, lat: lat, elevation: elevation, activity:activity, activity_certainty:activity_certainty)
    if(data_points.count == 0)
      self.elevation_gain = 0
      self.distance = 0
      self.duration = 0
      self.activity = data_point.activity
      self.avg_speed = 0
      self.current_speed = 0
      self.training_points = 0
    else
      dp = sorted_points.last
      data_point.save

      long_dist = (data_point.long - dp.long).abs
      lat_dist = (data_point.lat - dp.lat).abs
      dist = Math.sqrt(long_dist*long_dist + lat_dist*lat_dist)/360*EARTH_CIRCUMFERENCE
      self.distance += dist

      self.current_speed = dist/(data_point.created_at-dp.created_at).seconds

      puts dist
      puts self.current_speed
    end
    self.save
  end
end


