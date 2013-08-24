require 'test_helper'

class GameControllerTest < ActionController::TestCase
    test 'GET #new' do 
        games_count_before = Game.all.size
        player             = Player.find_by_token '23j0f023912309r5u11fas'

        get :new, token: player.token

        game_resp         = JSON.parse @response.body
        created_game      = Game.find game_resp['id']
        game_player       = created_game.players.first
        games_count_after = Game.all.size

        assert_equal 1, games_count_after - games_count_before
        assert_equal player.id, game_player.id
    end 
end 