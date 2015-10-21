class DataPointsController < ApplicationController
  require 'json'
  include LoginHelper
  before_filter :http_basic_authenticate, :check_point_params
  @user = nil
  def add_point
    @session = @user.training_sessions.find(params[:session_id])
    data = JSON.parse(params[:data])
    activity = data.find{|d| d['type']=='activity'}['activity']
    activity_certainty = data.find{|d| d['type']=='activity'}['certainty']
    lat = data.find{|d| d['type']=='location'}['latitude']
    long = data.find{|d| d['type']=='location'}['longitude']
    elevation = data.find{|d| d['type']=='location'}['elevation']
    @session.data_points.create(long: long, lat: lat, elevation: elevation, activity:activity, activity_certainty:activity_certainty)
    render json: {distance: activity}
  end

  private

    def check_point_params
      params.require(:data)
    end


end
