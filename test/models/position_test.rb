require 'test_helper'

class PositionTest < ActiveSupport::TestCase
  test 'collision should be detected' do
    p1 = Position.find_by :id => 1
    p2 = Position.find_by :id => 2
    p3 = Position.find_by :id => 3
    p4 = Position.find_by :id => 4
    p5 = Position.find_by :id => 5
    p6 = Position.find_by :id => 6
    p7 = Position.find_by :id => 7

    assert (p1.collision? p2), 'Collision not detected'
    assert (p2.collision? p1), 'Collision not detected'

    assert !(p3.collision? p1), 'Incorrect Collision detection '
    assert !(p3.collision? p1), 'Incorrect Collision detection '

    assert (p5.collision? p6), 'Collision not detected'
    assert (p6.collision? p5), 'Collision not detected'
    assert (p7.collision? p6), 'Collision not detected'
    assert (p6.collision? p7), 'Collision not detected'

  end
end
