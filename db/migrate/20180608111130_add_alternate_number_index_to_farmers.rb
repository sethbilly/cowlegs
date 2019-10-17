class AddAlternateNumberIndexToFarmers < ActiveRecord::Migration[5.1]
  def change
    add_index :farmers, :alternate_phone_number
  end
end
