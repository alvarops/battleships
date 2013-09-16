require 'test_helper'

class ShowBoardTest < ActionDispatch::IntegrationTest

  test 'GET show board' do
    get '23j0f023912309r5u11fas/game/new'
    assert_equal 200, @response.status

    new_game = JSON.parse @response.body
    id =  new_game['id'].to_s

    get '23j0f023912309r5u11fas/game/' + id + '/randomize'
    assert_equal 200, @response.status

    get '23j0f023912309r5u11fas/game/' + id + '/show'
    assert_equal 200, @response.status

    game = Game.find id

    resp = @response.body



    assert_equal ShipShapes::SHIP_TYPES.length ,game.boards.first.ships.length, 'wrong number of ships on board'

    assert resp.match(/#{game.width-1}x#{game.height-1}/), 'board size unknown'
    assert resp.match /data-width='#{game.width}'/
    assert resp.match /data-height='#{game.height}'/

    numberOfPixelsOfShipsForAPlayer = 145

    assert_equal numberOfPixelsOfShipsForAPlayer, (resp.scan '<td class="red">').size, 'Numbers of pixels does not match'

  end

end