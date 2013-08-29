class Board < ActiveRecord::Base
  belongs_to :game
  belongs_to :player

  has_many :ships

  validates_uniqueness_of :player_id, :scope => :game_id

  def randomize
    ships.destroy
    ShipShapes::SHIP_TYPES.keys.each do |type|
      generate_new_ship type
    end
  end

  def valid?
    self.ships.each do |ship1|
      self.ships.dup.remove(ship1).each do |ship2|
        if ship1.colide? ship2
          return false
        end
      end
    end
    true
  end

  private
  def generate_new_ship(type)
    s = Ship.generate(type, self.game.width, self.game.height)
    self.ships.each do |ship|
      if ship.colide? s
        generate_new_ship type
      end
    end
    self.ships.push s
  end
end
