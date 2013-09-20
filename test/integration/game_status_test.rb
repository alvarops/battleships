require 'test_helper'

class GameStatusTest < ActionDispatch::IntegrationTest

  test 'full end to end test' do
    # CREATE PLAYER 1
    get '/player/new?name=P1'
    resp = JSON.parse @response.body
    assert_equal 201, @response.status
    assert_equal 'P1', resp['name']
    token_1 = resp['token']
    id_1 = resp['id']

    # CREATE PLAYER 2
    get '/player/new?name=P2'
    resp = JSON.parse @response.body
    assert_equal 201, @response.status
    assert_equal 'P2', resp['name']
    id_2 = resp['id']
    token_2 = resp['token']

    #CREATE A NEW GAME
    get '/' + token_1 + '/game/new'
    assert_equal 200, @response.status
    resp = JSON.parse @response.body
    game_id = resp['id']
    assert_equal 'created', resp['status'], ' Incorrect game status'

    # JOIN SECOND PLAYER
    get '/' + token_2.to_s + '/game/' + game_id.to_s + '/join'
    assert_equal 200, @response.status
    resp = JSON.parse @response.body

    #CHECK GAME STATUS
    get '/' + token_2.to_s + '/game/' + game_id.to_s
    assert_equal 200, @response.status
    resp = JSON.parse @response.body
    assert_equal 'ready', resp['status'], ' Incorrect game status'

    #PLACE SHIPS ON PLAYER 1 BOARD
    get '/' + token_1.to_s + '/game/' + game_id.to_s + '/randomize'
    assert_equal 200, @response.status
    resp = JSON.parse @response.body

    #CHECK GAME STATUS AS PLAYER 1
    get '/' + token_1.to_s + '/game/' + game_id.to_s
    assert_equal 200, @response.status
    resp = JSON.parse @response.body
    assert_equal 'ready', resp['status'], ' Incorrect game status'

    #CHECK GAME STATUS AS PLAYER 2
    get '/' + token_2.to_s + '/game/' + game_id.to_s
    assert_equal 200, @response.status
    resp = JSON.parse @response.body
    assert_equal 'ready', resp['status'], ' Incorrect game status'

    #PLACE SHIPS ON PLAYER 2 BOARD
    get '/' + token_2.to_s + '/game/' + game_id.to_s + '/randomize'
    assert_equal 200, @response.status
    resp = JSON.parse @response.body

    #CHECK GAME STATUS
    get '/' + token_2.to_s + '/game/' + game_id.to_s
    assert_equal 200, @response.status
    resp = JSON.parse @response.body
    assert_equal 'fight', resp['status'], ' Incorrect game status'

    puts resp

  end

end