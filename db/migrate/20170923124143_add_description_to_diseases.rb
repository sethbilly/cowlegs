class AddDescriptionToDiseases < ActiveRecord::Migration[5.1]
  def change
    add_column :diseases, :description, :text
  end
end
