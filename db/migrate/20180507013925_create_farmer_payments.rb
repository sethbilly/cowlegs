class CreateFarmerPayments < ActiveRecord::Migration[5.1]
  def change
    create_table :farmer_payments do |t|
      t.references :farmer, foreign_key: true
      t.references :payment, foreign_key: true

      t.timestamps
    end
  end
end
