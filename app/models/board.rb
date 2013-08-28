class Board < ActiveRecord::Base
  belongs_to :game
  belongs_to :player

  has_many :ships

  validates_uniqueness_of :player_id, :scope => :game_id

  def randomize
    ships.destroy
    s = Ship.generate :t => :patrol, :width => self.game.width, :height => self.game.height
    self.ships.push s
  end
end
