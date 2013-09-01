require 'test_helper'

class NewShootTest < ActionDispatch::IntegrationTest
  test 'should use the right board ID' do
    get 'i_have_ships/game/3/shoot', {:x => 5, :y => 5}
    error = JSON.parse @response.body
    assert_not_nil error
    assert_equal 'Is not your game', error['error'][0]

    get 'i_have_no_ships/game/4/shoot', {:x => 5, :y => 7}
    shoot = JSON.parse @response.body
    assert_not_nil shoot
    assert_equal 10006, shoot['board_id']
  end

  test 'should shoot within the board bounds' do
    get '23j0f023912309r5u11fas/game/2/shoot', {:x => 100, :y => 5}
    error = JSON.parse @response.body
    assert_not_nil error
    assert_equal 'You shoot out of the board', error['error'][0]
  end

  test 'should shoot started games' do
    get '23j0f023912309r5u11fas/game/1/shoot', {:x => 5, :y => 5}
    error = JSON.parse @response.body
    assert_not_nil error
    assert_equal 'There is not opponent', error['error'][0]

    get '23j0f023912309r5u11fas/game/3/shoot', {:x => 5, :y => 5}
    error = JSON.parse @response.body
    assert_not_nil error
    assert_equal 'Is not ready', error['error'][0]

    get 'i_have_ships/game/4/shoot', {:x => 5, :y => 5}
    error = JSON.parse @response.body
    assert_not_nil error
    assert_equal 'Opponent ships are not ready', error['error'][0]
  end

  test 'should not be duplicate' do
    get 'i_have_no_ships/game/4/shoot', {:x => 6, :y => 5}
    get 'i_have_no_ships/game/4/shoot', {:x => 6, :y => 5}
    error = JSON.parse @response.body
    assert_not_nil error
    assert_equal 'Duplicate record', error['error'][0]
  end

  test 'should get a miss if no ship found' do
    get 'i_have_no_ships/game/4/shoot', {:x => 1, :y => 6}
    assert_equal '404', @response.code
  end

  test 'should get the ship description if hit' do
    get 'i_have_no_ships/game/4/shoot', {:x => 3, :y => 6}
    assert_equal '201', @response.code
    shoot = JSON.parse @response.body
    assert_not_nil shoot
    assert_equal 'submarine', shoot['ship_type']
    assert_equal 'hit', shoot['ship_status']
  end

  test 'should be able to sink the ship' do
    get 'i_have_no_ships/game/4/shoot', {:x => 4, :y => 1}
    assert_equal '201', @response.code
    get 'i_have_no_ships/game/4/shoot', {:x => 4, :y => 2}
    assert_equal '201', @response.code
    get 'i_have_no_ships/game/4/shoot', {:x => 4, :y => 3}
    assert_equal '201', @response.code

    shoot = JSON.parse @response.body
    assert_not_nil shoot
    assert_equal 'carrier', shoot['ship_type']
    assert_equal 'sunk', shoot['ship_status']
  end

  test 'should not let me shoot if all ships are sunk' do
    get 'i_have_no_ships/game/4/shoot', {:x => 3, :y => 6}
    get 'i_have_no_ships/game/4/shoot', {:x => 3, :y => 7}
    assert_equal '201', @response.code
    get 'i_have_no_ships/game/4/shoot', {:x => 3, :y => 5}
    assert_equal '201', @response.code
    shoot = JSON.parse @response.body
    assert_not_nil shoot
    assert_equal 'submarine', shoot['ship_type']
    assert_equal 'sunk', shoot['ship_status']

    get 'i_have_no_ships/game/4/shoot', {:x => 4, :y => 1}
    assert_equal '201', @response.code
    get 'i_have_no_ships/game/4/shoot', {:x => 4, :y => 2}
    assert_equal '201', @response.code
    get 'i_have_no_ships/game/4/shoot', {:x => 4, :y => 3}
    assert_equal '201', @response.code

    shoot = JSON.parse @response.body
    assert_not_nil shoot
    assert_equal 'carrier', shoot['ship_type']
    assert_equal 'sunk', shoot['ship_status']

    get 'i_have_no_ships/game/4/shoot', {:x => 4, :y => 7}
    assert_equal '200', @response.code
    error = JSON.parse @response.body
    assert_not_nil error
    assert_equal 'All your opponent ships are sunk', error['error'][0]
  end

end