class AddDetailsToPayments < ActiveRecord::Migration[5.1]
  def change
    add_column :payments, :debit_credit, :string
    add_column :payments, :amount, :decimal
    add_column :payments, :description, :string
  end
end
