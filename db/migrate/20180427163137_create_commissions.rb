class CreateCommissions < ActiveRecord::Migration[5.1]
  def change
    create_table :commissions do |t|
      t.decimal :amount, precision: 8, scale: 2
      t.references :user, foreign_key: true
      t.references :payment, foreign_key: true

      t.timestamps
    end
  end
end
