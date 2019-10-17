class AddNameOfLaboratoryToCases < ActiveRecord::Migration[5.1]
  def change
    add_column :cases, :name_of_laboratory, :string
  end
end
