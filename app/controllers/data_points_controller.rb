require 'json'

class DataPointsController < ApplicationController
  before_filter :check_point_params

  def add_point
    @session = @user.training_sessions.find(params[:session_id])

    data = JSON.parse(params[:data])
    activity = data.find{|d| d['type']=='activity'}['activity']
    activity_certainty = data.find{|d| d['type']=='activity'}['certainty']
    lat = data.find{|d| d['type']=='location'}['latitude']
    long = data.find{|d| d['type']=='location'}['longitude']
    elevation = data.find{|d| d['type']=='location'}['elevation']
    timestamp = DateTime.parse(data.find{|d| d['type']=='location'}['timestamp'])

    @session.add_point(long, lat, elevation, activity, activity_certainty,timestamp)

    render json: @session.to_json
  end

  private

    def check_point_params
      params.require(:data)
    end
end
