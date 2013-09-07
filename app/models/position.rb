class Position < ActiveRecord::Base
  belongs_to :ship

  def collision?(p2)
    if ((self.x - 1) <= p2.x && (self.x + 1) >= p2.x) && ((self.y - 1) <= p2.y && (self.y + 1) >= p2.y)
      return true
    end
    false
  end
end
