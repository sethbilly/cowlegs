class AddNumberOfAnimalsVaccinatedToVaccinationSchedules < ActiveRecord::Migration[5.1]
  def change
    add_column :vaccination_schedules, :number_of_animals_vaccinated, :integer, null: false, default: 0
    add_column :vaccination_schedules, :total_charge_for_vaccinations, :decimal, precision: 8, scale: 2, null: false, default: 0
  end
end
