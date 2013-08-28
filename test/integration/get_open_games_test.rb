require 'test_helper'

class GetOpenGamesTest < ActionDispatch::IntegrationTest

  test 'Should return list of empty games' do
    get '/23j0f023912309r5u11fas/game/list'

    assert_not_nil @response.body

    game = JSON.parse @response.body

    assert_equal 321, game[0]['width']
    assert_equal 123, game[0]['height']
    assert_equal 1, game[0]['id']

  end

end