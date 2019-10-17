class AddCropFieldsToFarmers < ActiveRecord::Migration[5.1]
  def change
    add_column :farmers, :is_livestock_farmer, :boolean, default: false
    add_column :farmers, :is_crop_farmer, :boolean, default: false
    add_column :farmers, :is_farm_maize, :boolean, default: false
    add_column :farmers, :is_farm_rice, :boolean, default: false
    add_column :farmers, :is_farm_soyabeans, :boolean, default: false
    add_column :farmers, :is_farm_sorghum, :boolean, default: false
    add_column :farmers, :is_farm_cocoa, :boolean, default: false
    add_column :farmers, :is_farm_yam, :boolean, default: false
    add_column :farmers, :acres_of_maize_farm, :integer
    add_column :farmers, :acres_of_rice_farm, :integer
    add_column :farmers, :acres_of_soyabeans_farm, :integer
    add_column :farmers, :acres_of_sorghum_farm, :integer
    add_column :farmers, :acres_of_cocoa_farm, :integer
    add_column :farmers, :acres_of_yam_farm, :integer
    add_column :farmers, :mode_of_farming, :string
    add_column :farmers, :is_use_fertilizer, :boolean, default: false
    add_column :farmers, :source_of_buying_fertilizer, :string
    add_column :farmers, :is_purchase_tractor_services, :boolean, default: false
    add_column :farmers, :is_purchase_seeds, :boolean, default: false
    add_column :farmers, :source_of_buying_seeds, :string
  end
end
