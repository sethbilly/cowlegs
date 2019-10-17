class CreateCampaignSubscriptions < ActiveRecord::Migration[5.1]
  def change
    create_table :campaign_subscriptions do |t|
      t.references :campaign, foreign_key: true
      t.references :farmer, foreign_key: true
      t.boolean :subscribed

      t.timestamps
    end
  end
end
