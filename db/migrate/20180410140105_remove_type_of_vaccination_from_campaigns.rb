class RemoveTypeOfVaccinationFromCampaigns < ActiveRecord::Migration[5.1]
  def change
    remove_column :campaigns, :type_of_vaccination, :string
  end
end
