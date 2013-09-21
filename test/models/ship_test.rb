require 'test_helper'
require 'ship_models'

class ShipTest < ActiveSupport::TestCase
  include ShipModels
  include ShipHelper

  test 'should create ship' do
    ship = Ship.create do |s|
      s.t = 'submarine'
      s.board_id = 1 #fake
    end

    assert_not_nil ship
  end

  test 'ships should not overlap on a board' do
    sub_horizontal = Ship.find_by(:id => 1)
    sub_vertical = Ship.find_by(:id => 2)
    assert (sub_horizontal.collide? sub_vertical), 'Ship collision not detected'
  end

  test 'ship width and height functions' do
    s = ShipModels::SHIP_MODELS[:battleship].first
    assert (ship_model_height s) == 4, 'incorect Ship height'
    assert (ship_model_width  s) == 1, 'incorrect ship width'

    s = ShipModels::SHIP_MODELS[:patrol].second
    assert (ship_model_height s) == 1, 'incorect Ship height'
    assert (ship_model_width  s) == 2, 'incorrect ship width'
  end

  test 'ships can have only certain types' do
    ship = Ship.new
    ship.board_id = 1 #fake

    ShipModels::SHIP_MODELS.each do |type|
      ship.t = type[0]
      assert_equal true, ship.save
    end

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
    board_width = Random.new.rand(20..30)
    board_height = Random.new.rand(20..30)

    ShipModels::SHIP_MODELS.each do |t, v|
      s = generate_ship_randomly t, board_width, board_height
      #s.print_ship board_height, board_width
      s.positions.each do |p|
        assert (p.x>=0 && p.x <= board_width && p.y>=0 && p.y <= board_height), 'Ship is NOT on a board ' + t.to_s + ' ' + s.to_json
      end
    end
  end

  test 'place ship on board' do
    ship = generate_ship 'cruiser', 0, 0, 0

    assert_equal 3, ship.positions.size


  end
end
