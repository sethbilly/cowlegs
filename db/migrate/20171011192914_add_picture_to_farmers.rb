class AddPictureToFarmers < ActiveRecord::Migration[5.1]
  def change
    add_column :farmers, :picture, :string
  end
end
