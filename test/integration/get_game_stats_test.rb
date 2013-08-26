require 'test_helper'

class GetGameStatsTest < ActionDispatch::IntegrationTest
  test 'should return game statistics' do
    get '23j0f023912309r5u11fas/game/1'

    game = JSON.parse @response.body

    assert_equal 0, game['players'].size
    assert_equal 0, game['boards'].size
  end
end