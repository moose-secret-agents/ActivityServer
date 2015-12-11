class TrainingSession < ActiveRecord::Base
  has_many :data_points
  EARTH_CIRCUMFERENCE = 6371000 * 2 * Math::PI#radius of earth in meters
  MIN_CHANGES = 3

  def conclude(username,password)
    act = "cycling"
    if self.activity == "RUNNING"
      act = "running"
    end

    attributes = { entryduration: self.duration.to_i, publicvisible: 2, courselength: self.distance.to_i, numberofrounds: self.training_points }

    client = Coach::Client.new

    client.authenticated(username, password) do
      entry = client.entries.create(username, act, attributes)
      return entry
    end
  end

  def add_point (long, lat, elevation, activity, activity_certainty, timestamp)
    sorted_points = data_points.sort_by {|dp| dp.created_at}
    data_point = data_points.new(long: long, lat: lat, elevation: elevation, activity:activity, activity_certainty:activity_certainty, created_at: timestamp)
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

      long_dist = calcLongDist(data_point.long - dp.long, dp.lat)
      lat_dist = calcLatDist(data_point.lat - dp.lat)
      dist = Math.sqrt(long_dist*long_dist + lat_dist*lat_dist)
      self.current_speed = dist/(data_point.created_at-dp.created_at).seconds
      activity_misses = 0
      tracking = false

      self.elevation_gain = 0
      self.distance = 0
      self.duration = 0
      self.avg_speed = 0
      positionlist = []
      #self.current_speed = 0

      sorted_points.each do |point|
        next if sorted_points.index(point) == 0
        index = sorted_points.index(point)
        previous_point = sorted_points[index-1]

        activity_misses = 0 if point.activity == self.activity
        activity_misses += 1 unless point.activity == self.activity

        if activity_misses >= MIN_CHANGES
          positionlist << {lat: point.lat, long: point.long, activity:point.activity}
          next
        else
          positionlist << {lat: point.lat, long: point.long, activity:self.activity}
        end
        activity_misses = 0
        prev_long = previous_point.long
        prev_lat = previous_point.lat

        long_dist = calcLongDist(point.long - prev_long, point.lat)
        lat_dist = calcLatDist(point.lat - prev_lat)
        dist = Math.sqrt(long_dist*long_dist + lat_dist*lat_dist)


        if point==dp
          max_allowed_speed = 1.1*self.current_speed + 1
          ratio = current_speed/max_allowed_speed
          puts "max_allowed_speed: #{max_allowed_speed}, current_speed: #{current_speed}, olddist: #{dist}, ratio: #{ratio}"
          if ratio > 1
            long_diff = point.long - prev_long
            lat_diff = point.lat - prev_lat
            point.long = 1/ratio * long_diff + prev_long
            point.lat = 1/ratio * lat_diff + prev_lat

            point.save

            long_dist = calcLongDist(point.long - prev_long,point.lat)
            lat_dist = calcLatDist(point.lat - prev_lat)
            dist = Math.sqrt(long_dist*long_dist + lat_dist*lat_dist)

            puts "newdist: #{dist}"
          end
        end
        self.distance += dist

        prev_elev = previous_point.elevation
        self.elevation_gain += point.elevation - previous_point.elevation if point.elevation > previous_point.elevation and previous_point.elevation != 0



        time_elapsed = point.created_at - previous_point.created_at
        self.duration += time_elapsed

        self.avg_speed = self.distance / self.duration
      end


      alternate_dist = 0
      if positionlist.length > 4
        for i in 0..positionlist.length-4 do
          pos = positionlist[i]
          lat = pos[:lat]
          long = pos[:long]
          refPos = positionlist[i+3]
          reflat = refPos[:lat]
          reflong = refPos[:long]
          refheading = {long: reflong-long,lat:reflat-lat}

          nextPos = positionlist[i+1]
          nextlat = nextPos[:lat]
          nextlong = nextPos[:long]
          nextheading = {long: nextlong-long,lat:nextlat-lat}
          dotpro = nextheading[:long]*refheading[:long] + nextheading[:lat]*refheading[:lat]
          interlat = dotpro * refheading[:lat] + lat
          interlong = dotpro * refheading[:long] + long
          nextPos[:lat] = ((interlat + nextlat)/2).round(10)
          nextPos[:long] = ((interlong + nextlong)/2).round(10)

          puts "nextPos: lat: #{nextPos[:lat]}, long: #{nextPos[:long]}"

          nextPos = positionlist[i+2]
          nextlat = nextPos[:lat]
          nextlong = nextPos[:long]
          nextheading = {long: nextlong-long,lat:nextlat-lat}
          dotpro = nextheading[:long]*refheading[:long] + nextheading[:lat]*refheading[:lat]
          interlat = dotpro * refheading[:lat] + lat
          interlong = dotpro * refheading[:long] + long
          nextPos[:lat] = ((interlat + nextlat)/2).round(10)
          nextPos[:long] = ((interlong + nextlong)/2).round(10)

          puts "nextPos: lat: #{nextPos[:lat]}, long: #{nextPos[:long]}"
        end
        for i in 1..positionlist.length-1 do
          long_dist = calcLongDist(positionlist[i][:long]-positionlist[i-1][:long],positionlist[i][:lat] )
          lat_dist = calcLatDist(positionlist[i][:lat]-positionlist[i-1][:lat],)
          dist = Math.sqrt(long_dist*long_dist + lat_dist*lat_dist)

          alternate_dist += dist if positionlist[i][:activity] == self.activity
        end
        puts "SMOOTHED DISTANCE: #{alternate_dist}"
        self.distance = alternate_dist
        self.avg_speed = self.distance / self.duration
        self.save
      end
      self.training_points = self.distance

      self.training_points += (self.elevation_gain * 3)

      self.training_points *=2 if(self.activity=="RUNNING")
    end
    self.save
  end
 # private
    def calcLatDist(distance)
      (distance).abs / 360 * EARTH_CIRCUMFERENCE
    end

    def calcLongDist(distance, latitude)
      (distance).abs / 360 * Math.cos((90-latitude)/180 * Math::PI) * EARTH_CIRCUMFERENCE
    end
end


