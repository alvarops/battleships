class AddColumnToGame < ActiveRecord::Migration
  def change
    add_column :games, :winner, :integer
  end
end
