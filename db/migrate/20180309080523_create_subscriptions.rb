class CreateSubscriptions < ActiveRecord::Migration[5.1]
  def change
    create_table :subscriptions do |t|
      t.datetime :expires_on
      t.integer :duration
      t.references :farmer, foreign_key: true

      t.timestamps
    end
  end
end
