Rails.application.routes.draw do

  scope '/api' do
    scope '/v1' do
      scope '/:session_id' do
        post '/conclude' => 'sessions#conclude_session'
        scope '/dataPoint' do
          post '/' => 'data_points#add_point'
        end
      end
      scope '/TrainingSession' do
        get '/' => 'sessions#create_session'
      end
    end
  end
end
