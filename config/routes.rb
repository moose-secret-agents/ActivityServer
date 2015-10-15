Rails.application.routes.draw do
  get 'data_points/addPoint'

  scope '/api' do
    scope '/v1' do
      scope '/dataPoint' do
        post '/' => 'data_points#add_point'
      end
    end
  end
end
