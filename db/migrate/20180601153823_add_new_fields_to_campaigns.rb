class AddNewFieldsToCampaigns < ActiveRecord::Migration[5.1]
  def change
    add_column :campaigns, :delivery_date, :date
    add_column :campaigns, :completion_date, :date
    add_column :campaigns, :status, :integer, default: 0
  end
end
