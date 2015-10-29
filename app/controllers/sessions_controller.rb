class SessionsController < ApplicationController
  before_filter :set_session, except: :create_session

  def create_session
    render json: { session_id: @user.training_sessions.create.id }
  end

  def conclude_session
    username, password = ActionController::HttpAuthentication::Basic::user_name_and_password(request)

    if @session.conclude(username, password)
      @session.destroy
      render json: { status: 'Successfully posted' }
    else
      head :unauthorized
    end
  end

  private
    def set_session
      @session = TrainingSession.find(params[:session_id])
      render json: {error: 'session not found'} if @session.nil?
    end
end
