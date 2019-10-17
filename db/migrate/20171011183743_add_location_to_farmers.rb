class AddLocationToFarmers < ActiveRecord::Migration[5.1]
  def change
    add_column :farmers, :location, :jsonb, null: false, default: {}
  end
end
