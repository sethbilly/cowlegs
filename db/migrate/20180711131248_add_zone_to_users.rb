class AddZoneToUsers < ActiveRecord::Migration[5.1]
  def change
    add_reference :users, :zone, foreign_key: true
  end
end
