class RemoveForeignKeysFromFarmer < ActiveRecord::Migration[5.1]
  def change
    remove_reference :farmers, :user, foreign_key: true
    remove_reference :farmers, :organization, foreign_key: true
  end
end
