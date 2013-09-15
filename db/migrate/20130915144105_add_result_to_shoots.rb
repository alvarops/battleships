class AddResultToShoots < ActiveRecord::Migration
  def change
    add_column :shoots, :result, :string
  end
end
