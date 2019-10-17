class AddIdTypeFieldsToFarmer < ActiveRecord::Migration[5.1]
  def change
    add_column :farmers, :id_type, :string
    add_column :farmers, :id_number, :string
    add_column :farmers, :languages_spoken, :string, array: true, default: []
  end
end
