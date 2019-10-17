class AddTypeOfSubscriptionToSubscriptions < ActiveRecord::Migration[5.1]
  def change
    add_column :subscriptions, :type_of_subscription, :integer, null: false, default: 0
  end
end
