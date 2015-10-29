class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  before_action :authenticate

  private
    def authenticate
      authenticate_with_http_basic do |username, password|
        @user = User.try_authenticate_or_retrieve(username, password)
        head :unauthorized unless @user
      end
    end
end

