require 'test_helper'

class RandomizeShipsTest < ActionDispatch::IntegrationTest

  test 'should radomize ships' do
    get '23j0f023912309r5u11fas/game/2/randomize'

    game = JSON.parse @response.body

    assert_not_nil game
  end

end