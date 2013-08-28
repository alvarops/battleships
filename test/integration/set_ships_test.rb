require 'test_helper'

$set_json =  [{
  type: 'submarine',
  xy: [
    [1, 1],
    [1, 2],
    [1, 3]
  ]
}]


class SetShipsTest < ActionDispatch::IntegrationTest
  test 'should set one ship on board' do
    post '23j0f023912309r5u11fas/game/2/set', ships: $set_json

    game = JSON.parse @response.body

    assert_not_nil game
  end
end