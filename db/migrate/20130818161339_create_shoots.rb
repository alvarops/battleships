class CreateShoots < ActiveRecord::Migration
  def change
    create_table :shoots do |t|
      t.integer :x, null: false, unsigned: true
      t.integer :y, null: false, unsigned: true
      t.integer :seq, unsigned: true
      t.integer :game_id, null: false
      t.integer :player_id, null: false

      t.timestamps
    end
  end
end
