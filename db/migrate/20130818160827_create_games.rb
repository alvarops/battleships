class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :statis
      t.integer :width, default: 10
      t.integer :height, default: 10

      t.timestamps
    end
  end
end
