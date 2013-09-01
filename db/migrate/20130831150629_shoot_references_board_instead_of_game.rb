class ShootReferencesBoardInsteadOfGame < ActiveRecord::Migration
  def change
    add_column :shoots, :board_id, :integer
    remove_column :shoots, :game_id
  end
end
