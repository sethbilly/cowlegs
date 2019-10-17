class AddHasSubscribedToFarmers < ActiveRecord::Migration[5.1]
  def change
    add_column :farmers, :has_subscribed, :boolean, default: false
  end
end
