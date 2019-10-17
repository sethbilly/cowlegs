class AddMoreFieldsToCases < ActiveRecord::Migration[5.1]
  def change
    add_column :cases, :age, :string
    add_column :cases, :sex, :string
    add_column :cases, :system, :string
    add_column :cases, :number_dead, :integer
    add_column :cases, :number_at_risk, :integer
    add_column :cases, :number_examined, :integer
    add_column :cases, :measures_adopted, :string
    add_column :cases, :epidemiology, :text
    add_column :cases, :tentative_diagnosis, :text
    add_column :cases, :differential_diagnosis, :text
    add_column :cases, :basis_for_diagnosis, :string
    add_column :cases, :samples_sent_to_lab, :boolean
    add_column :cases, :date_of_sample_submission, :date
    remove_column :cases, :number_of_animals
  end
end
