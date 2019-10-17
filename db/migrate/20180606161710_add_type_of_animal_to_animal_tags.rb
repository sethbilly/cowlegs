class AddTypeOfAnimalToAnimalTags < ActiveRecord::Migration[5.1]
  def change
    add_column :animal_tags, :type_of_animal, :string
  end
end
