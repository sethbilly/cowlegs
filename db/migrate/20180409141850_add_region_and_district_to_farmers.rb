class AddRegionAndDistrictToFarmers < ActiveRecord::Migration[5.1]
  def change
    add_reference :farmers, :region, foreign_key: true
    add_reference :farmers, :district, foreign_key: true
  end
end
