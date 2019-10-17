class AddAnimalGroupToVaccinationSchedules < ActiveRecord::Migration[5.1]
  def change
    add_column :vaccination_schedules, :animal_group, :string
  end
end
