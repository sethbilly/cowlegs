class AddNotesToAnimalTagVaccinations < ActiveRecord::Migration[5.1]
  def change
    add_column :animal_tag_vaccinations, :notes, :text
  end
end
