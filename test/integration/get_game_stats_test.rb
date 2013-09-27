require 'test_helper'

class GetGameStatsTest < ActionDispatch::IntegrationTest
  test 'should return game statistics' do
    get '23j0f023912309r5u11fas/game/1'

    game = JSON.parse @response.body

    assert_equal 1, game['players'].size
    assert_equal 1, game['boards'].size


  end

  test 'should return list of shots' do
    get 'i_have_no_ships/game/4/shoot', {:x => 3, :y => 6}
    get 'i_have_no_ships/game/4/shoot', {:x => 3, :y => 7}
    assert_equal '200', @response.code
    get 'i_have_no_ships/game/4/shoot', {:x => 3, :y => 5}
    assert_equal '200', @response.code
    shoot = JSON.parse @response.body
    assert_not_nil shoot
    assert_equal 'submarine', shoot['ship_type']
    assert_equal 'sunk', shoot['ship_status']

    get 'i_have_no_ships/game/4/shoot', {:x => 8, :y => 8}

    get 'i_have_no_ships/game/4'

    game = JSON.parse @response.body
    assert_equal 4, game['boards'][1]['shoots'].size
    assert_equal 'hit', game['boards'][1]['shoots'][0]['result']
    assert_equal 'hit', game['boards'][1]['shoots'][1]['result']
    assert_equal 'hitsunk', game['boards'][1]['shoots'][2]['result']
    assert_equal 'miss', game['boards'][1]['shoots'][3]['result']


  end
end

