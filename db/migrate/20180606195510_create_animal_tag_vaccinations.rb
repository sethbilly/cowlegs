class CreateAnimalTagVaccinations < ActiveRecord::Migration[5.1]
  def change
    create_table :animal_tag_vaccinations do |t|
      t.string :type_of_vaccination
      t.references :animal_tag, foreign_key: true
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
