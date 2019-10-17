class AddRegionAndDistrictToCampaigns < ActiveRecord::Migration[5.1]
  def change
    add_reference :campaigns, :region, foreign_key: true
    add_reference :campaigns, :district, foreign_key: true
  end
end
