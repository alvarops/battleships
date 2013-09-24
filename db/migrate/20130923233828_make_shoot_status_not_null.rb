class MakeShootStatusNotNull < ActiveRecord::Migration
  def change
    change_column :shoots, :result, :string, :null => false
  end
end
