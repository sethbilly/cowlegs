class AddDebitCreditToUserPayments < ActiveRecord::Migration[5.1]
  def change
    add_column :user_payments, :credit, :decimal
    add_column :user_payments, :debit, :decimal
    add_column :user_payments, :description, :string
  end
end
