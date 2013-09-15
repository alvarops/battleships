require 'test_helper'

class BoardTest < ActiveSupport::TestCase

  test 'Create board just for fun.' do
    board = mock_board

    assert_not_nil board.id, 'Board id should be not null'
  end

  test 'Can place ship on board?' do
    board = mock_board

    ship1 = Ship.new do |s|
      s.t = :patrol
      s.positions.push Position.new x: 0, y: 0
    end

    ship2 = Ship.new do |s|
      s.t = :patrol
      s.positions.push Position.new x: 0, y: 0
    end

    board.ships.push ship1

    can_place = board.can_place? ship2

    assert_equal false, can_place

  end

  private

  def mock_board
    Board.create do |b|
      b.game_id = 1234 #game_id must not be null
      b.player_id = 1234 #palyer_id must not be null
    end
  end
end
