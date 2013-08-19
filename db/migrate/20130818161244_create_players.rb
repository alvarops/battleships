class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :name, null: false
      t.string :token, null: false
      t.integer :won, default: 0
      t.integer :lost, default: 0

      t.timestamps
    end
  end
end
