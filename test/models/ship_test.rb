require 'test_helper'
require 'ship_shapes'

class ShipTest < ActiveSupport::TestCase
  include ShipShapes
  test 'should create ship' do
    ship = Ship.create do |s|
      s.t = 'submarine'
      s.board_id = 1 #fake
    end

    assert_not_nil ship
  end

  test 'ships can have only certain types' do
    ship = Ship.new
    ship.board_id = 1 #fake
    ship.t = 'submarine'
    assert_equal true, ship.save
    ship.t = 'carrier'
    assert_equal true, ship.save
    ship.t = 'battleship'
    assert_equal true, ship.save
    ship.t = 'cruiser'
    assert_equal true, ship.save
    ship.t = 'patrol'
    assert_equal true, ship.save
    ship.t = 'unknown'
    assert_equal false, ship.save
  end

  test 'ships can be generated randomly' do
    board_width = 15
    board_height = 20

    ShipShapes::SHIP_TYPES.each do |t, v|
      s = Ship.generate t, board_width, board_height
      s.print_ship
      s.positions.each do |p|
        assert (p.x>=0 && p.x <= board_width && p.y>=0 && p.y <= board_height), 'Ship is NOT on a board ' + t.to_s + ' ' + s.to_json
      end
    end
  end
end
