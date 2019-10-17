class AddCommunityToCases < ActiveRecord::Migration[5.1]
  def change
    add_column :cases, :community, :string
  end
end
