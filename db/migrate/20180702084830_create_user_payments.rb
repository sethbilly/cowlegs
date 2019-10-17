class CreateUserPayments < ActiveRecord::Migration[5.1]
  def change
    create_table :user_payments do |t|
      t.references :user, foreign_key: true
      t.references :payment, foreign_key: true

      t.timestamps
    end
  end
end
