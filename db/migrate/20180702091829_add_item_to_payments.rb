class AddItemToPayments < ActiveRecord::Migration[5.1]
  def change
    add_column :payments, :item, :string, null: false, default: ''
  end
end
