class CreatePayments < ActiveRecord::Migration[5.1]
  def change
    create_table :payments do |t|
      t.references :subscription, foreign_key: true
      t.decimal :payment_fee, precision: 8, scale: 2

      t.timestamps
    end
  end
end
