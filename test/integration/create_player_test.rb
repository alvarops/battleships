require "test_helper"

class CreatePlayerTest < ActionDispatch::IntegrationTest

    test 'GET player#new' do 
        get "/player/new?name=Bob"
         #check response

        resp = JSON.parse @response.body

        assert_equal 'Bob', resp['name']

        assert_equal 201, @response.status
    end 

    test 'POST player#new' do 
        post "/player/new", '{"name": "Bob"}', "CONTENT_TYPE" => 'application/json'

        resp = JSON.parse @response.body

        assert_equal 'Bob', resp['name']
        refute_nil resp['token']
    end
end 