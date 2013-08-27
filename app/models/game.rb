class Game < ActiveRecord::Base
  include TimestampSuppress

  has_many :shoots, dependent: :delete_all
  has_many :boards, dependent: :delete_all
  has_many :players, through: :boards

  before_save :update_state

  validate :max_two_players

  private

  def update_state 
    if self.players.size == 2
      self.status = 'ready'
    elsif self.players.size < 2
      self.status = 'created'
    end 
  end 

  def max_two_players 
    if self.players.size > 2
      errors.add :game, 'has many players'
    end
  end 
end
