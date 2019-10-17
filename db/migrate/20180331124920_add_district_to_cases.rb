class AddDistrictToCases < ActiveRecord::Migration[5.1]
  def change
    add_column :cases, :district, :string
    add_column :cases, :details_of_diagnosis, :string
  end
end
