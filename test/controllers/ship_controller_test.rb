require 'test_helper'

class ShipControllerTest < ActionController::TestCase
  test "should get list" do
    get :list
    assert_equal ShipModels::SHIP_MODELS.to_json, @response.body, 'Incorrect list of ships'
    assert_response :success
  end

end
