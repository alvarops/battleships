require 'test_helper'

class GameTest < ActiveSupport::TestCase
 	test 'Create game should just create it.' do
   	Game.create do |g|
   		g.width = 100
   		g.height = 100
   	end 

   	g = Game.last

   	assert_equal 100, g.width
   	assert_equal 100, g.height
	end

  test 'Create game with default values' do
    g = Game.create
    g.save

    assert_equal 10, g.width
    assert_equal 10, g.height
  end 

	test 'Creating game and adding players should create boards for them.' do
		player1 = Player.create do |p|
			p.name = 'Joe'
		end 

		player2 = Player.create do |p|
			p.name = 'Frank'
		end 

		game = Game.create do |g|
			g.width = 10
			g.height = 10
		end 

		game.players.push player1
		game.players.push player2


		assert game.boards.size == 2, 'Game should have two boards.'
	end 

  test 'Adding same player twice to same game should not create new board.' do
    player = Player.create do |p|
      p.name = 'Frank'
    end 

    game = Game.create do |g|
      g.width = 10
      g.height = 10
    end 

    game.players.push player

    assert_raises ActiveRecord::RecordInvalid do 
      #trying to add the same user again to the same game    
      game.players.push player
      game.save!
    end 

    game.save

    #let's check what landed in db (should be just one board)

    our_game = Game.find(game.id);

    assert our_game.boards.size == 1, 'Game should have only one board.'
  end 

  test 'Newly created games should have status "created"' do
    game = Game.create do |g|
      g.width = 10
      g.height = 10
    end

    assert_equal 'created', game.status
  end

  test 'Adding 2 users should change game status to "ready", and removing back to "created"' do
    game = Game.create do |g| 
      g.width = 10
      g.height = 10
    end 

    fred = Player.create do |p| 
      p.name = 'Fred'
    end 

    joe = Player.create do |p| 
      p.name = 'Joe'
    end 

    game.players.push fred
    game.players.push joe 
    game.save

    assert_equal 'ready', game.status

    game.players.delete(fred)
    game.save

    assert_equal 'created', game.status
  end 

  test 'Cannot add more than 2 players to the game' do 
    players = []

    for i in 0..3 do 
      players[i] = Player.create do |p|
        p.name = 'Name #{i}'
      end 
    end 

    game = Game.create do |g|
      g.width = 10
      g.height = 10
    end 

    game.players.push players[0]
    game.players.push players[1]
    game.players.push players[2]

    #ok so far, but now we expect... exception 
    assert_raises ActiveRecord::RecordInvalid do       
      game.save!
    end
  end

  test 'For created game, should return current player board and opponent\'s board too' do
    players = []

    for i in 0..2 do
      players[i] = Player.create do |p|
        p.name = 'Name #{i}'
      end
    end

    game = Game.create do |g|
      g.width = 10
      g.height = 10
    end

    game.players.push players[0]
    game.players.push players[1]

    players_board = game.player_board players[0].id
    opponents_board = game.opponent_board players[0].id

    assert_not_nil players_board
    assert_equal players[0].id, players_board.player_id

    assert_not_nil opponents_board
    assert_equal players[1].id, opponents_board.player_id


  end

end
