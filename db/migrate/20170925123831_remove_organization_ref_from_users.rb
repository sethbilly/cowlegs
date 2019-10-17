class RemoveOrganizationRefFromUsers < ActiveRecord::Migration[5.1]
  def change
    remove_reference :users, :organization, foreign_key: true
  end
end
