class Shoot < ActiveRecord::Base
  belongs_to :board
  belongs_to :player

  validate :board_exists#, :game_is_started

  private
  def board_exists
    errors.add  :board, 'does not exist' if self.board.nil?
  end

  private

  #def game_is_started
  #  if self.board.game.status != 'started'
  #    errors.add  :board, 'is not started'
  #  end
  #end
end
