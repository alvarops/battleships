require 'test_helper'

class BoardTest < ActiveSupport::TestCase
    test "Create board just for fun." do 
        board = Board.create do |b|
            b.game_id = 1234 #game_id must not be null
            b.player_id = 1234 #palyer_id must not be null
        end 

        assert_not_nil board.id, "Board id should be not null"
    end 
end
