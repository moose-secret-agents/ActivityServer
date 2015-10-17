class DataPointsController < ApplicationController
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

    def http_basic_authenticate
      authenticate_or_request_with_http_basic do |username, password|
        @user = User.try_authenticate_or_retrieve(username, password)
        if @user.nil?
          render json: {status: 'Unauthorized'}, :status => :unauthorized
          return false
        end
        true
      end
    end
end
