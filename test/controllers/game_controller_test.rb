require 'test_helper'

class GameControllerTest < ActionController::TestCase
  test 'GET #new' do
    games_count_before = Game.all.size

    get :new, token: token

    games_count_after = Game.all.size

    game_resp    = JSON.parse @response.body
    created_game = Game.find game_resp['id']

    player      = Player.find_by_token token
    game_player = created_game.players.first

    assert_equal 1, games_count_after - games_count_before
    assert_equal player.id, game_player.id
  end

  test 'POST #set' do
    post :set, params

    player_board = current_player_board(params)

    assert_equal 3, player_board.ships.size
    assert_equal params[:ships][0][:type], player_board.ships.first.t.to_s
  end

  test 'GET #set, ship has to have right size' do

    post :set, params
    #TODO

  end

  private

  def current_player_board(params)
    current_player = assigns :current_player
    game = Game.find params[:id]
    game.boards.find_by player_id: current_player.id
  end

  def params
    {
      token: token, #current player token
      id: 3, #game id
      ships: [{
        type: 'submarine', #type of the boat
        xy: [
          [1, 1], #position of the boat (we assume game size is 10x10)
          [1, 2],
          [1, 3]
        ]
      }]
    }
  end

  def broken_params
    {
      token: token, #current player token
      id: 2, #game id
      ships: [{
        type: 'submarine', #type of the boat
        xy: [
          [1, 1], #position of the boat (we assume game size is 10x10)
          [1, 2],
          [1, 3]
        ]
      }]
    }
  end

end 