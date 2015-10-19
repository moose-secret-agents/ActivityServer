class DataPointsController < ApplicationController
  include LoginHelper
  before_filter :http_basic_authenticate, :check_point_params
  @user = nil
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
