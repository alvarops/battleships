require 'test_helper'

class ShowBoardTest < ActionDispatch::IntegrationTest

  test 'GET show board' do
    get '23j0f023912309r5u11fas/game/2/randomize'
    get '23j0f023912309r5u11fas/game/2/show'

    #check response

    resp = @response.body

    assert_equal 200, @response.status

    numberOfPixelsOfShipsForAPlayer = 17

    assert resp.match(/9x9/) , 'board size unknown'
    assert resp.match /data-width='10'/
    assert resp.match /data-height='10'/

    puts resp
    assert_equal numberOfPixelsOfShipsForAPlayer, (resp.scan '<td class="red">').size, 'Numbers of pixels does not match'

  end

end