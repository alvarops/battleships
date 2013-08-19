require 'test_helper'

class PlayerControllerTest < ActionController::TestCase
    test 'GET #new' do
        get :new

        player = Player.find_by name: 'Anonymous'

        assert_equal 'Anonymous', player.name
    end 

    test 'GET #new, {name}' do 
        get :new, {name: 'Bob'}

        player = Player.find_by name: 'Bob'

        assert_equal 'Bob', player.name
        assert_kind_of String, player.token
    end 

    test 'POST #new' do 
        post :new, {name: 'Frank'}

        player = Player.find_by name: 'Frank'

        assert_equal 'Frank', player.name
    end     

    test 'GET #stats' do 
        #player defined in fixtures
        get :stats, {id: 12345, token: '23j0f023912309r5u11fas'}

        current_player =  assigns(:current_player)

        assert_equal 12345, current_player.id
    end 
end