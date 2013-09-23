require 'test_helper'

class GameStatusTest < ActionDispatch::IntegrationTest


  test 'full end to end test with randomized ships' do
    player1, player2 = create_and_verify_players()
    game = create_and_verify_game(player1)
    join_game(game, player2)

    request_and_verify_game_status(game, player2, 'ready')

    randomize_ships(game, player1)
    request_and_verify_game_status(game, player1, 'ready')

    randomize_ships(game, player2)
    request_and_verify_game_status(game, player2, 'fight')
  end

  test 'full end to end test with randomized ships and GAME RESTART' do
    player1, player2 = create_and_verify_players()
    game = create_and_verify_game(player1)
    join_game(game, player2)

    request_and_verify_game_status(game, player2, 'ready')

    randomize_ships(game, player1)
    request_and_verify_game_status(game, player1, 'ready')

    randomize_ships(game, player2)
    request_and_verify_game_status(game, player2, 'fight')

    get "/#{player1['token']}/game/#{game['id']}/restart/#{player2['token']}"
    request_and_verify_game_status(game, player2, 'fight')

  end

  test 'full end to end test with 1 manually set and 1 randomized board' do
    player1, player2 = create_and_verify_players()
    game = create_and_verify_game(player1)
    join_game(game, player2)

    request_and_verify_game_status(game, player2, 'ready')

    randomize_ships(game, player1)
    request_and_verify_game_status(game, player1, 'ready')

    set_ships_manually(game, player2)
    request_and_verify_game_status(game, player2, 'fight')
  end

  test 'full end to end test with 1 randomized and 1 manually set board' do
    player1, player2 = create_and_verify_players()
    game = create_and_verify_game(player1)
    join_game(game, player2)

    request_and_verify_game_status(game, player2, 'ready')

    set_ships_manually(game, player1)
    request_and_verify_game_status(game, player1, 'ready')

    randomize_ships(game, player2)
    request_and_verify_game_status(game, player2, 'fight')
  end

  test 'full end to end test with 2 manually set boards' do
    player1, player2 = create_and_verify_players()
    game = create_and_verify_game(player1)
    join_game(game, player2)

    request_and_verify_game_status(game, player2, 'ready')

    set_ships_manually(game, player1)
    request_and_verify_game_status(game, player1, 'ready')

    set_ships_manually(game, player2)
    request_and_verify_game_status(game, player2, 'fight')
  end

  test 'shooting test' do
    player1, player2 = create_and_verify_players()
    game = create_and_verify_game(player1)
    join_game(game, player2)

    request_and_verify_game_status(game, player2, 'ready')

    set_ships_manually(game, player1)
    request_and_verify_game_status(game, player1, 'ready')

    randomize_ships(game, player2)
    request_and_verify_game_status(game, player2, 'fight')

    gameModel = Game.find game['id']

    board2 = gameModel.opponent_board player1['id']
    shoot_count = shoot_all_ships(board2, game, player1)
    assert_equal shoot_count, board2.shoots.length, 'Number of logged shoots doesnt match number of actual shoots'
    request_and_verify_game_status(game, player1, 'fight')
    get "/#{player1['token']}/game/#{game['id']}/shoot/?x=0&y=0"
    assert_equal "All your opponent's ships are sunk", resp_body['error'][0], "Missing error message: #{resp_body}"

    board1 = gameModel.opponent_board player2['id']
    shoot_count = shoot_all_ships(board1, game, player2)
    number_of_shots_to_board1_saved_in_db = board1.shoots.length
    assert_equal shoot_count, number_of_shots_to_board1_saved_in_db, 'Number of logged shoots doesnt match number of actual shoots'

    get "/#{player2['token']}/game/#{game['id']}/shoot/?x=0&y=0"
    assert_equal "All your opponent's ships are sunk", resp_body['error'][0], 'Missing error message'

    assert_equal number_of_shots_to_board1_saved_in_db, board1.shoots.length, 'Unexpected number of shoots'

    request_and_verify_game_status(game, player2, 'end')
  end


  private

  def shoot_all_ships(board, game, player)
    shoot_count = 0
    board.ships.each do |s|
      s.positions.each do |p|
        get "/#{player['token']}/game/#{game['id']}/shoot/?x=#{p.x}&y=#{p.y}"
        assert resp_body['ship_status'].include?('hit') || resp_body['ship_status'].include?('sunk'), "Unexpected miss: Resp=#{resp_body['ship_status']}"
        shoot_count +=1
      end
    end
    shoot_count
  end


  def set_ships_manually(game, player)
    # change game width so it will be easier to set ships manually in this test
    g = Game.find game['id']
    g.width = 500
    g.height = 10
    g.save

    x = 0
    y = 0

    ShipModels::SHIP_MODELS.each do |s|
      ships = [{
                   type: s[0],
                   xy: [x, y],
                   variant: 0
               }]

      post "/#{player['token']}/game/#{game['id']}/set", ships: ships
      assert_equal 200, @response.status
      resp = JSON.parse @response.body
      assert resp['error'].nil?, "ERROR when setting a ship: #{resp['error']}"
      assert_equal game['id'], resp['id'], 'ship was not set'
      x += 15
    end

    board = g.player_board player['id']
    assert_equal ShipModels::SHIP_MODELS.length, board.ships.length, 'Incorrect number of ships on the board'
  end

  def resp_body
    JSON.parse @response.body
  end


  def resp
    @response
  end

  def create_and_verify_game(player)
    get "/#{player['token']}/game/new"
    game = resp_body
    verify_game(game, 'created', 1)
    game
  end

  def request_and_verify_game_status(game, player, game_status)
    get "/#{player['token']}/game/#{game['id']}"
    assert_equal 200, resp.status
    verify_game_status resp_body, game_status
  end


  def join_game(game, player)
    get "/#{player['token']}/game/#{game['id']}/join"
    assert_equal 200, resp.status
  end

  def create_and_verify_players
    player1 = create_player 'P1'
    verify_player player1, 'P1'

    player2 = create_player 'P2'
    verify_player player2, 'P2'
    return player1, player2
  end

  def create_player(name)
    get "/player/new?name=#{name}"
    resp_body
  end

  def randomize_ships(game, player)
    get "/#{player['token']}/game/#{game['id']}/randomize"
    assert_equal 200, @response.status
  end

  def verify_player(player, name)
    assert_equal 201, resp.status
    assert_equal name, player['name']
    assert_equal 22, player['token'].length
    assert_equal 0, player['won']
    assert_equal 0, player['lost']
    assert_not_nil player['id']
  end

  def verify_game(game, status, no_of_players)
    assert_equal 200, resp.status
    assert_equal status, game['status'], 'Incorrect game status'
    assert game['width'] > 0
    assert game['height'] > 0
    assert game['id'] > 0
    assert_equal no_of_players, game['players'].length
  end

  def verify_game_status(game, status)
    assert_not_nil game['id']
    assert_not_nil game['width']
    assert_not_nil game['height']

    assert_equal status, game['status'], 'Incorrect game status'

    players = game['players']

    assert_equal 2, players.length
    verify_game_player players[0], 'P1'
    verify_game_player players[1], 'P2'

    boards = game['boards']

    assert_equal 2, boards.length
    verify_board boards[0], players[0]['id'], game['id']
    verify_board boards[1], players[1]['id'], game['id']

  end

  def verify_game_player(player, name)
    assert_equal name, player['name']
    assert_nil player['token'] #token cannot be exposed in the game satus
    assert_not_nil player['id']
    assert_equal 0, player['won']
    assert_equal 0, player['lost']
  end

  def verify_board(board, player_id, game_id)
    assert_not_nil board['id']
    assert_equal player_id, board['player_id']
    assert_equal game_id, board['game_id']
  end
end