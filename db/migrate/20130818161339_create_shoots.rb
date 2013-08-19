class CreateShoots < ActiveRecord::Migration
  def change
    create_table :shoots do |t|
      t.integer :x
      t.integer :y
      t.integer :seq
      t.integer :game_id
      t.integer :player_id

      t.timestamps
    end
  end
end
