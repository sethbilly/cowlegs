class AddDeviceIdsToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :device_ids, :string, null: false, array: true, default: []
  end
end
