class Board < ActiveRecord::Base
  belongs_to :game
  belongs_to :player

  has_many :ships

  validates_uniqueness_of :player_id, :scope => :game_id

  def randomize
    ships.destroy
    ShipShapes::SHIP_TYPES.keys.each do |type|
      s = Ship.generate(type, self.game.width, self.game.height)
      self.ships.push s
    end
  end
end
