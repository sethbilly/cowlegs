class RenameTypeOnTypeOfCampaigns < ActiveRecord::Migration[5.1]
  def change
  	rename_column :type_of_campaigns, :type, :type_of_campaign
  end
end
