class AddDistrictAndZoneToCases < ActiveRecord::Migration[5.1]
  def change
    add_reference :cases, :district, foreign_key: true
    add_reference :cases, :zone, foreign_key: true
  end
end
