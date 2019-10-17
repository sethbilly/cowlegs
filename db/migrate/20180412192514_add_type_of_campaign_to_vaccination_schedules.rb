class AddTypeOfCampaignToVaccinationSchedules < ActiveRecord::Migration[5.1]
  def change
  	remove_column :vaccination_schedules, :type_of_vaccination, :string
    add_reference :vaccination_schedules, :type_of_campaign, foreign_key: true
  end
end
