class Board < ActiveRecord::Base
  belongs_to :game
  belongs_to :player

  has_many :ships
  has_many :shoots, dependent: :delete_all

  validates_uniqueness_of :player_id, :scope => :game_id
  validate :valid_ships

  def randomize
    ships.destroy
    ShipShapes::SHIP_TYPES.keys.each do |type|
      generate_new_ship type
    end
  end

  private

  def valid_ships(board=self)
    self.ships.each do |ship1|
      self.ships.each do |ship2|
        if (ship1 <=> ship2) && (ship1.collide? ship2)
          return false
        end
      end
    end
    true
  end

  def generate_new_ship(type)
    s = Ship.generate(type, self.game.width, self.game.height)
    self.ships.each do |ship|
      if ship.collide? s
        return generate_new_ship type
      end
    end
    self.ships.push s
  end
end
