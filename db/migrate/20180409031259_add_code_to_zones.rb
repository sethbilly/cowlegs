class AddCodeToZones < ActiveRecord::Migration[5.1]
  def change
    add_column :zones, :code, :integer
  end
end
