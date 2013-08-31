require 'test_helper'

class ShootTest < ActiveSupport::TestCase
  test 'should create shoot' do

    shoot = Shoot.create do |s|
      s.player_id = 1 #Player.find_by_token('adflkj23kj23lkj235l;23')
      s.board_id = 1
      s.x = 5
      s.y = 5
    end
    assert_not_nil shoot
  end
end
