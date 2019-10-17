class AddAlternatePhoneNumberToFarmers < ActiveRecord::Migration[5.1]
  def change
    add_column :farmers, :alternate_phone_number, :string
    add_index :farmers, :alternate_phone_number, unique: true
  end
end
