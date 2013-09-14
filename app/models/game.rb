class Game < ActiveRecord::Base
  has_many :boards, dependent: :delete_all
  has_many :players, through: :boards

  before_save :update_state

  validate :max_two_players

  def player_board current_player_id
    Board.find_by player_id: current_player_id, game_id: self.id
  end


  def opponent_board current_player_id
    self.boards.select { |b| b.player_id != current_player_id }.first
  end

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
