require 'test_helper'

class NewShootTest < ActionDispatch::IntegrationTest
  test 'should use the right board ID' do
    get 'i_have_ships/game/3/shoot', {:x => 5, :y => 5}
    shoot = JSON.parse @response.body
    assert_not_nil shoot
    assert_equal 'Is not your game', shoot['error'][0]

    get 'i_have_no_ships/game/4/shoot', {:x => 5, :y => 7}
    shoot = JSON.parse @response.body
    assert_not_nil shoot
    assert_equal 10006, shoot['board_id']
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
    puts @response.body
    assert_not_nil shoot
    assert_equal 'submarine', shoot['ship_type']
  end
end