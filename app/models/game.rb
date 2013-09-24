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

  def finished?
    return true if self.status == 'finished'
    return false if self.status != 'fight'

    game_finished = true

    self.boards.each do |board|
      game_finished &&= board.finished?
    end

    game_finished
  end

  def finalize
    self.status = 'finished'
    determine_winner
    save
  end

  def determine_winner
    count_p1 = boards.first.shoots.count
    count_p2 = boards.last.shoots.count
    if count_p1 > count_p2
      self.winner = boards.first.player_id
    elsif count_p1 < count_p2
      self.winner = boards.last.player_id
    else
      self.winner = -1 # DRAW
    end
  end

  private

  def update_state
    if self.status != 'finished' and self.status != 'fight'
      if self.players.size == 2
        self.status = 'ready'
      elsif self.players.size < 2
        self.status = 'created'
      end
    end
  end

  def max_two_players
    if self.players.size > 2
      errors.add :game, 'has many players'
    end
  end

end
