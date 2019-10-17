class AddTypeOfCampaignToCampaigns < ActiveRecord::Migration[5.1]
  def change
    add_reference :campaigns, :type_of_campaign, foreign_key: true
    add_column :campaigns, :code, :string
    add_index :campaigns, :code, unique: true
  end
end
