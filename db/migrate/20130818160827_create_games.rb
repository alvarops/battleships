class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :statis
      t.integer :width
      t.integer :height

      t.timestamps
    end
  end
end
