class AddTransactionNumberPayments < ActiveRecord::Migration[5.1]
  def change
    add_column :payments, :transaction_number, :string
  end
end
