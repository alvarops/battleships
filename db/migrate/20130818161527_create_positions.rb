class CreatePositions < ActiveRecord::Migration
  def change
    create_table :positions do |t|
      t.integer :x
      t.integer :y
      t.integer :shop_id

      t.timestamps
    end
  end
end
