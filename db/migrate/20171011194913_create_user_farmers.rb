class CreateUserFarmers < ActiveRecord::Migration[5.1]
  def change
    create_table :user_farmers do |t|
      t.references :user, foreign_key: true
      t.references :farmer, foreign_key: true

      t.timestamps
    end
  end
end
