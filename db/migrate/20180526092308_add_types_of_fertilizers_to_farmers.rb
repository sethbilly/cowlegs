class AddTypesOfFertilizersToFarmers < ActiveRecord::Migration[5.1]
  def change
    add_column :farmers, :types_of_fertilizers, :string
  end
end
