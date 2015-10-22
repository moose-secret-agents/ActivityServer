class TrainingSession < ActiveRecord::Base
  has_many :data_points
  EARTH_CIRCUMFERENCE = 6371000 * 2 * Math::PI#radius of earth in meters
  MIN_CHANGES = 3
  def add_point (long, lat, elevation, activity, activity_certainty)
    sorted_points = data_points.sort_by {|dp| dp.created_at}
    data_point = data_points.new(long: long, lat: lat, elevation: elevation, activity:activity, activity_certainty:activity_certainty)
    if(data_points.count == 0)
      self.elevation_gain = 0
      self.distance = 0
      self.duration = 0
      self.activity = data_point.activity
      self.running_count=0
      self.cycling_count=0
      self.avg_speed = 0
      self.current_speed = 0
      self.training_points = 0
    else
      dp = sorted_points.last
      data_point.save

      self.running_count+=1 if data_point.activity == 'RUNNING'
      self.cycling_count+=1 if data_point.activity == 'ON_BICYCLE'
      self.activity = self.running_count>self.cycling_count ? 'RUNNING' : 'ON_BICYCLE'

      long_dist = (data_point.long - dp.long).abs
      lat_dist = (data_point.lat - dp.lat).abs
      dist = Math.sqrt(long_dist*long_dist + lat_dist*lat_dist)/360*EARTH_CIRCUMFERENCE

      activity_misses = 0
      tracking = false

      self.elevation_gain = 0
      self.distance = 0
      self.duration = 0
      self.avg_speed = 0
      self.current_speed = 0

      sorted_points.each do |point|
        next if sorted_points.index(point) == 0
        index = sorted_points.index(point)
        previous_point = sorted_points[index-1]
        activity_misses += 1 unless point.activity == self.activity
        next if activity_misses >= MIN_CHANGES
        activity_misses = 0
        prev_long = previous_point.long
        prev_lat = previous_point.lat
        long_dist = (point.long - prev_long).abs
        lat_dist = (point.lat - prev_lat).abs
        dist = Math.sqrt(long_dist*long_dist + lat_dist*lat_dist)/360*EARTH_CIRCUMFERENCE
        self.distance += dist

        time_elapsed = point.created_at - previous_point.created_at
        self.duration += time_elapsed

        self.avg_speed = self.distance / self.duration

        prev_elev = previous_point.elevation
        self.elevation_gain += point.elevation - previous_point.elevation if point.elevation > previous_point.elevation and previous_point.elevation != 0
      end

      self.current_speed = dist/(data_point.created_at-dp.created_at).seconds

    end
    self.save
  end
end


