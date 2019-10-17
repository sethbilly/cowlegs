class AddFertilizerCountsToFarmers < ActiveRecord::Migration[5.1]
  def change
    add_column :farmers, :number_of_npk_bags, :integer, null: false, default: 0
    add_column :farmers, :number_of_urea_bags, :integer, null: false, default: 0
    add_column :farmers, :number_of_soa_bags, :integer, null: false, default: 0
  end
end
