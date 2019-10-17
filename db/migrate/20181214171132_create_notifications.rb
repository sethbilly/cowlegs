class CreateNotifications < ActiveRecord::Migration[5.1]
  def change
    create_table :notifications do |t|
      t.references :messages , foreign_key: true
      t.boolean :scheduled
      t.datetime :send_at
      t.boolean :sent

      t.timestamps
    end
  end
end
