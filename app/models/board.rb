class Board < ActiveRecord::Base
  belongs_to :game
  belongs_to :player

  has_many :ships
  has_many :shoots, -> {order 'created_at'}

  validates_uniqueness_of :player_id, :scope => :game_id
  validate :valid_ships

  def randomize
    self.ships.destroy_all
    ShipShapes::SHIP_TYPES.keys.each do |type|
      generate_new_ship type
    end
  end

  def can_place? new_ship
    self.ships.each do |existing_ship|
      return false if new_ship.collide? existing_ship
    end
    true
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
    s = Ship.generate_randomly(type, self.game.width, self.game.height)
    self.ships.each do |ship|
      if ship.collide? s
        return generate_new_ship type
      end
    end
    self.ships.push s
  end

end
