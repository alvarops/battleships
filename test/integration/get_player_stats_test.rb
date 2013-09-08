require 'test_helper'

class GetPlayerStatsTest < ActionDispatch::IntegrationTest
    test 'should return player statistics object WITHOUT token' do
        get '/player/12345'

        resp = JSON.parse @response.body

        assert_equal 123, resp['won']
        assert_equal 321, resp['lost']
    end

    test 'should return player statistics object WITH token' do
      get '/23j0f023912309r5u11fas/player/12345'

      resp = JSON.parse @response.body

      assert_equal 123, resp['won']
      assert_equal 321, resp['lost']
    end
end 