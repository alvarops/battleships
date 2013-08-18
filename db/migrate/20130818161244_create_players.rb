class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :name
      t.string :token
      t.integer :won
      t.integer :lost

      t.timestamps
    end
  end
end
