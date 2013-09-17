class AddStatusToShoot < ActiveRecord::Migration
  def change
    add_column :shoots, :status, :string
  end
end
