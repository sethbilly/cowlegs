class AddZoneToFarmers < ActiveRecord::Migration[5.1]
  def change
    add_reference :farmers, :zone, foreign_key: true
  end
end
