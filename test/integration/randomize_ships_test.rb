require 'test_helper'

class RandomizeShipsTest < ActionDispatch::IntegrationTest

  test 'should radomize ships' do
    get '23j0f023912309r5u11fas/game/2/randomize'
    assert_equal 200, @response.status
  end

  test 'randomize function shoud work only where there is no ships' do
    get '23j0f023912309r5u11fas/game/new'
    assert_equal 200, @response.status

    new_game = JSON.parse @response.body
    id =  new_game['id'].to_s

    get '23j0f023912309r5u11fas/game/' + id + '/randomize'
    assert_equal 200, @response.status


    #TODO: return a non-html error when randomize called twice

    get '23j0f023912309r5u11fas/game/' + id + '/randomize'
    assert_equal 403, @response.status

  end

end