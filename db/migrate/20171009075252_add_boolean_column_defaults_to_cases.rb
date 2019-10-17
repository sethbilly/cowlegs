class AddBooleanColumnDefaultsToCases < ActiveRecord::Migration[5.1]
  def change
  	change_column_default :cases, :samples_sent_to_lab, false
  	remove_column :cases, :feed_changed
  	remove_column :cases, :lasted_for
  end
end
