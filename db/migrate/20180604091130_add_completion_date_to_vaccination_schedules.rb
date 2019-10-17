class AddCompletionDateToVaccinationSchedules < ActiveRecord::Migration[5.1]
  def change
    add_column :vaccination_schedules, :completion_date, :date
  end
end
