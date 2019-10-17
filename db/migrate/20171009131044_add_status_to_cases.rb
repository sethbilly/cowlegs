class AddStatusToCases < ActiveRecord::Migration[5.1]
  def change
    add_column :cases, :status, :integer, default: 0
  end
end
