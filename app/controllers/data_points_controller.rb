class DataPointsController < ApplicationController
  before_filter :check_point_params
  def add_point
    data = params[:data].to_json
    puts data
    render json: data
  end
  private

  def check_point_params
    params.require(:data)
  end
end
