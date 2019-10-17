class RemoveLocationAndDesignationFromOrganizations < ActiveRecord::Migration[5.1]
  def change
    remove_column :organizations, :location, :jsonb
    remove_column :organizations, :designation, :string
  end
end
