class RemoveUnusedFieldsFromCampaigns < ActiveRecord::Migration[5.1]
  def change
    remove_column :campaigns, :active, :boolean
    remove_column :campaigns, :start_date, :date
    remove_column :campaigns, :end_date, :date
    remove_column :campaigns, :zone_id, :integer
  end
end
