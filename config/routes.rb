Rails.application.routes.draw do

  scope '/api' do
    scope '/v1' do
      scope '/:session_id/dataPoint' do
        post '/' => 'data_points#add_point'
      end
      scope '/TrainingSession' do
        get '/' => 'sessions#create_session'
        get '/conclude' => 'sessions#conclude_session'

      end
    end
  end
end
