require 'test_helper'

class DataPointsControllerTest < ActionController::TestCase
  test "should get addPoint" do
    get :addPoint
    assert_response :success
  end

end
