class AddSlugToCampaigns < ActiveRecord::Migration[5.1]
  def change
    add_column :campaigns, :slug, :string
  end
end
