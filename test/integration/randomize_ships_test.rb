require 'test_helper'

class RandomizeShipsTest < ActionDispatch::IntegrationTest

  test 'should radomize ships' do
    get '23j0f023912309r5u11fas/game/2/randomize'
    assert_equal 200, @response.status
  end

  test 'randomize function shoud work only where there is no ships' do
    get '23j0f023912309r5u11fas/game/new'
    assert_equal 200, @response.status

    new_game = JSON.parse @response.body
    id =  new_game['id'].to_s

    get '23j0f023912309r5u11fas/game/' + id + '/randomize'
    assert_equal 200, @response.status

    game = Game.find id

    board = game.player_board 12345
    myShips = board.ships

    assert_equal myShips.length, ShipShapes::SHIP_TYPES.length, 'Unexpected number of ships on the board'

    get '23j0f023912309r5u11fas/game/' + id + '/randomize'

    status = JSON.parse @response.body

    assert_equal 'You are not allow to modify your board any more', status['error'], 'Expected error didnt happen'

  end

end