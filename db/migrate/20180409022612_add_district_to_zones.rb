class AddDistrictToZones < ActiveRecord::Migration[5.1]
  def change
    add_reference :zones, :district, foreign_key: true
  end
end
