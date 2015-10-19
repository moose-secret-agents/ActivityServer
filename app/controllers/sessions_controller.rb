class SessionsController < ApplicationController
  include LoginHelper
  before_filter :http_basic_authenticate
  before_filter :set_session, except: :create_session
  def create_session
    render json: {session_id: @user.training_sessions.create().id()}
  end

  def conclude_session
    render json: {id: @session.id()}
  end

  private
    def set_session
      @session = TrainingSession.find(params[:id])
    end
end
