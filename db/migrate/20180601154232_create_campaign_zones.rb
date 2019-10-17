class CreateCampaignZones < ActiveRecord::Migration[5.1]
  def change
    create_table :campaign_zones do |t|
      t.references :zone, foreign_key: true
      t.references :campaign, foreign_key: true

      t.timestamps
    end
  end
end
