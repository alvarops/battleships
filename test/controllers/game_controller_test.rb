require 'test_helper'

class GameControllerTest < ActionController::TestCase
  test 'GET #new' do
    games_count_before = Game.all.size

    get :new, token: token

    games_count_after = Game.all.size

    game_resp = JSON.parse @response.body
    created_game = Game.find game_resp['id']

    player = Player.find_by_token token
    game_player = created_game.players.first

    assert_equal 1, games_count_after - games_count_before
    assert_equal player.id, game_player.id
  end

  test 'GET #new - Board size should not be bigger than expected' do
    20.times do
      games_count_before = Game.all.size
      get :new, token: token
      games_count_after = Game.all.size
      game_resp = JSON.parse @response.body
      created_game = Game.find game_resp['id']
      assert_equal 1, games_count_after - games_count_before
      board_size = created_game.width * created_game.height
      assert board_size <= (GameController::MAX_NUMBER_OF_PIXELS + GameController::VARIABLE_SIZE * created_game.width), 'Game board is too big. Size=' + board_size.to_s + " W=" + created_game.width.to_s + " H=" + created_game.height.to_s
      assert board_size >= (GameController::MAX_NUMBER_OF_PIXELS - (1 + GameController::VARIABLE_SIZE) * created_game.width), 'Game board is too small. Size=' + board_size.to_s + " W=" + created_game.width.to_s + " H=" + created_game.height.to_s
    end
  end

  test 'GET #new Create game and join a second player with a single request' do
    games_count_before = Game.all.size

    get :new, token: token, secondPlayerId: 12346

    games_count_after = Game.all.size

    game_resp = JSON.parse @response.body
    created_game = Game.find game_resp['id']

    player = Player.find_by_token token
    first_game_player = created_game.players.first
    second_game_player = created_game.players.second

    assert_equal 1, games_count_after - games_count_before, 'Game not created at all in db'
    assert_equal player.id, first_game_player.id, 'First player Id incorrect'
    assert_equal 12346, second_game_player.id, 'Second player ID incorrect'
  end

  test 'POST #set' do
    post :set, params

    first_ship_type = params[:ships][0][:type]

    player_board = current_player_board params

    assert_equal 1, player_board.ships.size

    assert_equal first_ship_type, player_board.ships.first.t.to_s
    assert_equal 3, player_board.ships.first.positions.size
  end

  test 'POST #set, multiple ships' do
    post :set, params_multiple

    player_board = current_player_board(params_multiple)

    assert_equal 18, player_board.ships.size
    assert_equal 3, player_board.ships.find_by(t: :submarine).positions.size
    assert_equal 2, player_board.ships.find_by(t: :patrol).positions.size
    assert_equal 5, player_board.ships.find_by(t: :carrier).positions.size
  end

  test 'GET #set, ship has to have right size' do
    post :set, params

    game = Game.find(params[:id])

    assert_equal 1, game.player_board(12345).ships.size
  end

  test 'GET #shoot, {x, y}' do
    shoots_count_before = Shoot.all.size

    get :shoot, token: 'i_have_no_ships', id: 4, x: 1, y: 1

    shoots_count_after = Shoot.all.size
    assert_equal shoots_count_after, 1 + shoots_count_before
  end

  private

  def current_player_board(params)
    current_player = assigns :current_player
    game = Game.find params[:id]
    game.player_board current_player.id
  end

  def params
    {
      token: token, #current player token
      id: 2, #game id
      ships: [{
        type: 'submarine', #type of the boat
        xy: [1, 1], #position of the boat (we assume game size is 10x10)
        variant: 0
      }]
    }
  end

  def params_multiple
    ships = []
    offset= 0
    ShipModels::SHIP_MODELS.each do |t, st|
      ships.push ({
        type: t.to_s,
        xy: [offset, 1],
        variant: 0
      })
      offset += 10
    end

    {
      token: 'fpq3hjf-q39jhg-q304hgr20',
      id: 5,
      ships: ships
    }
  end

end 