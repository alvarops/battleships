require 'test_helper'

class BoardTest < ActiveSupport::TestCase
    test "Create board just for fun." do 
        board = Board.create do |b|
        end 

        assert_not_nil board.id, "Board id should be not null"
    end 
end
