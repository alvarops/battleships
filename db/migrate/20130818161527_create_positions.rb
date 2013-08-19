class CreatePositions < ActiveRecord::Migration
  def change
    create_table :positions do |t|
      t.integer :x, null: false, unsigned: true
      t.integer :y, null: false, unsigned: true
      t.integer :shop_id, null: false

      t.timestamps
    end
  end
end
