class RemoveAlternateNumberIndexFromFarmers < ActiveRecord::Migration[5.1]
  def change
    remove_index :farmers, :alternate_phone_number
  end
end
