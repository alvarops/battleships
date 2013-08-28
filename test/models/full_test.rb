require 'test_helper'

class BoardTest < ActiveSupport::TestCase

  test 'should play the game between models' do

    game = Game.new

    player_one = Player.new
    player_two = Player.new

    player_one.name = 'Alvaro'
    player_two.name = 'Alvaro 2'

    game.width = 10
    game.height = 10

    game.players.push player_one
    game.players.push player_two

    game.save

    ship = Ship.new
    ship.t = 'patrol'

    p1 = Position.new
    p1.x = 0
    p1.y = 0

    p2 = Position.new
    p2.x = 1
    p2.y = 0


    ship.positions.push p1
    ship.positions.push p2

    board = game.boards.find_by(player_id: player_one.id)

    board.ships.push ship

    game.save
    board.save


  end

end