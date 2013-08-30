require 'test_helper'

class RandomizeShipsTest < ActionDispatch::IntegrationTest

  test 'should radomize ships' do
    get '23j0f023912309r5u11fas/game/2/randomize'

    puts @response.body
  end


  test 'ship width and height functions' do
    s = ShipShapes::SHIP_TYPES[:battleship].first
    assert (Ship::ship_height s)==4, 'incorect Ship height'
    assert (Ship::ship_width s)==1, 'incorrect ship width'

    s = ShipShapes::SHIP_TYPES[:patrol].second
    assert (Ship::ship_height s)==1, 'incorect Ship height'
    assert (Ship::ship_width s)==2, 'incorrect ship width'
  end
end