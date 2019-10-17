class AddIsDeletedToFarmers < ActiveRecord::Migration[5.1]
  def change
    add_column :farmers, :is_deleted, :boolean, null: false, default: false
  end
end
