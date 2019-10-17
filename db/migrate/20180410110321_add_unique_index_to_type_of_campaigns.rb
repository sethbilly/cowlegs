class AddUniqueIndexToTypeOfCampaigns < ActiveRecord::Migration[5.1]
  def change
  	add_index :type_of_campaigns, :type, unique: true
  	add_index :type_of_campaigns, :code, unique: true
  end
end
