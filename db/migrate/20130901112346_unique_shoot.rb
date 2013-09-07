class UniqueShoot < ActiveRecord::Migration
  def change
      add_index :shoots, [:board_id, :x, :y], :unique => true
  end
end
