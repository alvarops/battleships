class CreateBoards < ActiveRecord::Migration
  def change
    create_table :boards do |t|
      t.integer :game_id, null: false
      t.integer :player_id, null: false

      t.timestamps
    end
  end
end
