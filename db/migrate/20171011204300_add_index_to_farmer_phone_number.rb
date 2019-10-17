class AddIndexToFarmerPhoneNumber < ActiveRecord::Migration[5.1]
  def change
  	add_index :farmers, :phone_number, unique: true
  end
end
