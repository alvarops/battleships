require 'test_helper'

class GameTest < ActiveSupport::TestCase
   	test "Create game should just create it." do
     	Game.create do |g|
     		g.width = 100
     		g.height = 100
     	end 

     	g = Game.last

     	assert_equal 100, g.width
     	assert_equal 100, g.height
  	end

    test "Create game with default values" do 
      g = Game.create
      g.save

      assert_equal 10, g.width
      assert_equal 10, g.height
    end 

  	test "Creating game and adding players should create boards for them." do
  		player1 = Player.create do |p|
  			p.name = "Joe"
  		end 

  		player2 = Player.create do |p|
  			p.name = "Frank"
  		end 

  		game = Game.create do |g|
  			g.width = 10
  			g.height = 10
  		end 

  		game.players.push player1
  		game.players.push player2


  		assert game.boards.size == 2, "Game should have two boards."
  	end 

    test "Adding same player twice to same game should not create new board." do 
        player = Player.create do |p|
            p.name = "Frank"
        end 

        game = Game.create do |g|
            g.width = 10
            g.height = 10
        end 

        game.players.push player

        assert_raises ActiveRecord::RecordInvalid do 
            #trying to add the same user again to the same game    
            game.players.push player
        end 

        game.save

        #let's check what landed in db (should be just one board)

        our_game = Game.find(game.id);

        assert our_game.boards.size == 1, "Game should have only one board."
    end 
end
