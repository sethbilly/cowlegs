class AddInstallmentFieldsToSubcriptions < ActiveRecord::Migration[5.1]
  def change
    add_column :subscriptions, :total_cost_of_subscription, :decimal, precision: 8, scale: 2
    add_column :subscriptions, :total_amount_paid, :decimal, precision: 8, scale: 2
    add_column :subscriptions, :total_amount_due, :decimal, precision: 8, scale: 2
  end
end
