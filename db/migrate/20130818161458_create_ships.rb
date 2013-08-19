class CreateShips < ActiveRecord::Migration
  def change
    create_table :ships do |t|
      t.string :t, null: false
      t.integer :board_id, null: false

      t.timestamps
    end
  end
end
