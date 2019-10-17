class AddSlugToFarmer < ActiveRecord::Migration[5.1]
  def change
    add_column :farmers, :slug, :string, after: :id
  end
end
