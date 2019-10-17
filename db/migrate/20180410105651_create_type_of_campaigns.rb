class CreateTypeOfCampaigns < ActiveRecord::Migration[5.1]
  def change
    create_table :type_of_campaigns do |t|
      t.string :type
      t.integer :code

      t.timestamps
    end
  end
end
