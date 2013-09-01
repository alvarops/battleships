class Shoot < ActiveRecord::Base
  belongs_to :board
  belongs_to :player

  validate :game_is_started

  private

  def game_is_started
    if self.board.nil?
      errors.add  :error, 'There is not opponent'
    elsif !self.board.game.players.find_by(id:self.player.id)
      errors.add :error, 'Is not your game'
    elsif self.board.game.status != 'ready'
      errors.add  :error, 'Is not ready'
    elsif board.ships.size == 0
      errors.add  :error, 'Opponent ships are not ready'
    elsif board.ships.all? { |s| s.status == :sunk }
      errors.add :error, 'All your opponent ships are sunk'
    end
  end

end

