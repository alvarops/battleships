require 'test_helper'

class NewShootTest < ActionDispatch::IntegrationTest
  test 'should shoot started games' do
    get '23j0f023912309r5u11fas/game/2/shoot', {:x => 5, :y => 5}

    shoot = JSON.parse @response.body
    assert_not_nil shoot
    assert_equal shoot['board_id'], 10002
  end
end