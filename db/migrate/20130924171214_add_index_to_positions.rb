class AddIndexToPositions < ActiveRecord::Migration
  def change
    add_index :boards, :player_id
    add_index :boards, :game_id
    add_index :shoots, :board_id
    add_index :shoots, :player_id
    add_index :ships, :board_id
    add_index :positions, :ship_id
  end
end
