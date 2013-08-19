require 'test_helper'

class PlayerTest < ActiveSupport::TestCase
  test "should not save player without a name" do
  	player = Player.new
    assert !player.save, "Should not save player without name."
  end

  test "should save player with a name" do 
  	player = Player.new 
  	player.name = "Joe"
  	player.save

  	player_out = Player.last

  	assert player_out.name == "Joe", "Player's name should be Joe"
  end
end
