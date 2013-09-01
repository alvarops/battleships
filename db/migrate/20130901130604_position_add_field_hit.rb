class PositionAddFieldHit < ActiveRecord::Migration
  def change
    add_column :positions, :hit, :boolean, :default => false
  end
end
