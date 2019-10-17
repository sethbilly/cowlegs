class AddDebitCreditToFarmerPayments < ActiveRecord::Migration[5.1]
  def change
    add_column :farmer_payments, :credit, :decimal
    add_column :farmer_payments, :debit, :decimal
    add_column :farmer_payments, :description, :string
  end
end
