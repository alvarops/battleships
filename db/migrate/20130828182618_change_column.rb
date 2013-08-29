class ChangeColumn < ActiveRecord::Migration
  def change
    change_column :ships, :board_id, :integer, :null => true
  end
end
