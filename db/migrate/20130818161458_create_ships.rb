class CreateShips < ActiveRecord::Migration
  def change
    create_table :ships do |t|
      t.string :t
      t.integer :board_id

      t.timestamps
    end
  end
end
