class AddRegionToOrganizations < ActiveRecord::Migration[5.1]
  def change
    add_column :organizations, :region, :string
    add_column :organizations, :district, :string
  end
end
