require 'test_helper'

class ShowBoardTest < ActionDispatch::IntegrationTest

  test 'GET show board' do
    get '23j0f023912309r5u11fas/game/2/randomize'
    assert_equal 200, @response.status

    get '23j0f023912309r5u11fas/game/2/show'

    #check response

    game = Game.find 2

    b = Board.find 10002
    assert_equal ShipShapes::SHIP_TYPES.length ,b.ships.length, 'wrong number of ships on board'
    resp = @response.body

    assert_equal 200, @response.status

    numberOfPixelsOfShipsForAPlayer = 17

    assert resp.match(/#{game.width-1}x#{game.height-1}/), 'board size unknown'
    assert resp.match /data-width='#{game.width}'/
    assert resp.match /data-height='#{game.height}'/

    assert_equal numberOfPixelsOfShipsForAPlayer, (resp.scan '<td class="red">').size, 'Numbers of pixels does not match'

  end

end