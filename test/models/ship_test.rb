require 'test_helper'

class ShipTest < ActiveSupport::TestCase
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
    Ship.SHIP_TYPES.each do |t, v|
      s = Ship.generate t, 10, 20
      assert s.valid_points?, 'Invalid Ship ' + s.positions.to_json
    end
  end
end
