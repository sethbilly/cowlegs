class AddRescheduleDateToVaccinationSchedules < ActiveRecord::Migration[5.1]
  def change
    add_column :vaccination_schedules, :reschedule_date, :date
    add_column :vaccination_schedules, :reschedule_reason, :text
  end
end
