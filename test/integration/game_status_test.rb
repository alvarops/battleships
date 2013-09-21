require 'test_helper'

class GameStatusTest < ActionDispatch::IntegrationTest


  test 'full end to end test' do
    player1, player2 = create_and_verify_players()
    game = create_and_verify_game(player1)
    join_game(game, player2)

    request_and_verify_game_status(game, player2, 'ready')

    randomize_ships(game, player1)
    request_and_verify_game_status(game, player1, 'ready')

    randomize_ships(game, player2)
    request_and_verify_game_status(game, player2, 'fight')
  end

  private

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
    assert_equal 201,  resp.status
    assert_equal name, player['name']
    assert_equal 22,   player['token'].length
    assert_equal 0,    player['won']
    assert_equal 0,    player['lost']
    assert_not_nil     player['id']
  end

  def verify_game(game, status, no_of_players)
    assert_equal 200, resp.status
    assert_equal status, game['status'], 'Incorrect game status'
    assert game['width']  > 0
    assert game['height'] > 0
    assert game['id']     > 0
    assert_equal no_of_players, game['players'].length
  end

  def verify_game_status(game, status)
    assert_not_nil game['id']
    assert_not_nil game['width']
    assert_not_nil game['height']

    assert_equal status, game['status'], 'Incorrect game status'

    players = game['players']

    assert_equal 2,    players.length
    verify_game_player players[0], 'P1'
    verify_game_player players[1], 'P2'

    boards = game['boards']

    assert_equal 2, boards.length
    verify_board boards[0], players[0]['id'], game['id']
    verify_board boards[1], players[1]['id'], game['id']

  end

  def verify_game_player(player, name)
    assert_equal name, player['name']
    assert_nil         player['token'] #token cannot be exposed in the game satus
    assert_not_nil     player['id']
    assert_equal 0,    player['won']
    assert_equal 0,    player['lost']
  end

  def verify_board(board, player_id, game_id)
    assert_not_nil board['id']
    assert_equal player_id, board['player_id']
    assert_equal game_id,   board['game_id']
  end
end