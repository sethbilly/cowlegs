class RemoveDescriptionFromCases < ActiveRecord::Migration[5.1]
  def change
    remove_column :cases, :description, :string
  end
end
