class SessionsController < ApplicationController
  include LoginHelper
  before_filter :http_basic_authenticate
  before_filter :set_session, except: :create_session
  def create_session
    render json: {session_id: @user.training_sessions.create().id()}
  end

  def conclude_session
    @entry = nil
    username, password = ActionController::HttpAuthentication::Basic::user_name_and_password(request)

    @entry = @session.conclude(username,password)
    stat = :ok
    response = {status: "successfully posted"}

    if @entry.nil?
      response = {status: 'Unauthorized'}
      stat = :unauthorized
    else
      @session.destroy()
    end
    render json: response, status: stat
  end

  private
    def set_session
      @session = TrainingSession.find(params[:session_id])
      render json: {error: 'session not found'} if @session.nil?
      return
    end


end
