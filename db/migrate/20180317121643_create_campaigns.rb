class CreateCampaigns < ActiveRecord::Migration[5.1]
  def change
    create_table :campaigns do |t|
      t.string :type_of_vaccination
      t.boolean :active, default: true
      t.date :start_date
      t.date :end_date
      t.references :zone, foreign_key: true

      t.timestamps
    end
  end
end
