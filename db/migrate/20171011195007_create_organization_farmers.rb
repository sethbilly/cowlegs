class CreateOrganizationFarmers < ActiveRecord::Migration[5.1]
  def change
    create_table :organization_farmers do |t|
      t.references :organization, foreign_key: true
      t.references :farmer, foreign_key: true

      t.timestamps
    end
  end
end
