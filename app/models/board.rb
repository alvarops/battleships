class Board < ActiveRecord::Base
  belongs_to :game
  belongs_to :player

  has_many :ships

  validates_uniqueness_of :player_id, :scope => :game_id
end
