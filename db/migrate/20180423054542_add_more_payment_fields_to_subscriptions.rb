class AddMorePaymentFieldsToSubscriptions < ActiveRecord::Migration[5.1]
  def change
    add_reference :subscriptions, :user, foreign_key: true
    add_reference :subscriptions, :pricing_plan, foreign_key: true
  end
end
