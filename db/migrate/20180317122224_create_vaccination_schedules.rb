class CreateVaccinationSchedules < ActiveRecord::Migration[5.1]
  def change
    create_table :vaccination_schedules do |t|
      t.string :activity
      t.string :type_of_vaccination
      t.integer :herd_size
      t.references :zone, foreign_key: true
      t.text :notes
      t.references :farmer, foreign_key: true
      t.references :campaign, foreign_key: true

      t.timestamps
    end
  end
end
