class CreateCampaignMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :campaign_messages do |t|
      t.references :message, foreign_key: true
      t.references :campaign, foreign_key: true

      t.timestamps
    end
  end
end
