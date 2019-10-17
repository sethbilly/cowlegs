class AddUnitCostOfVaccineToCampaigns < ActiveRecord::Migration[5.1]
  def change
    add_column :campaigns, :unit_cost_of_vaccine, :decimal, precision: 8, scale: 2, null: false, default: 0
  end
end
