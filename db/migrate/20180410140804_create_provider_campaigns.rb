class CreateProviderCampaigns < ActiveRecord::Migration[5.1]
  def change
    create_table :provider_campaigns do |t|
      t.references :campaign, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
