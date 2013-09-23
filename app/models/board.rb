class Board < ActiveRecord::Base
  include ShipHelper

  belongs_to :game
  belongs_to :player

  has_many :ships
  has_many :shoots, -> { order 'created_at' }

  validates_uniqueness_of :player_id, :scope => :game_id
  validate :valid_ships

  def randomize
    self.ships.destroy_all
    ShipModels::SHIP_MODELS.keys.each do |type|
      generate_new_ship type
    end
  end

  def can_place?(new_ship)
    if collide_with_others?(new_ship) or is_out_of_the_board?(new_ship) or already_exist?(new_ship)
      return false
    end
    true
  end



  def finished?
    all_shots_fired? or all_ships_sunk?
  end

  private

  def all_shots_fired?
    (self.shoots.size == self.game.width * self.game.height)
  end

  def all_ships_sunk?
    (self.ships.all? { |s| s.status == :sunk })
  end


  def already_exist?(ship)
    self.ships.each do |existing_ship|
      return true if ship.t == existing_ship.t
    end
    false
  end

  def collide_with_others?(ship)
    self.ships.each do |existing_ship|
      return true if ship.collide? existing_ship
    end
    false
  end

  def is_out_of_the_board?(ship)
    max_x = ship.positions.map(&:x).max
    max_y = ship.positions.map(&:y).max
    max_x > self.game.width or max_y > self.game.height
  end

  def valid_ships
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
    s = generate_ship_randomly(type, self.game.width, self.game.height)
    self.ships.each do |ship|
      if ship.collide? s
        return generate_new_ship type
      end
    end
    self.ships.push s
  end

end
