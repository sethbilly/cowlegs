class ChangeHasSubscribedName < ActiveRecord::Migration[5.1]
  def change
  	rename_column :farmers, :has_subscribed, :subscribed
  end
end
