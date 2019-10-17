class CreateFarmers < ActiveRecord::Migration[5.1]
  def change
    create_table :farmers do |t|
      t.string :first_name
      t.string :last_name
      t.string :phone_number
      t.string :sex
      t.integer :age
      t.string :level_of_education
      t.string :region
      t.string :district
      t.string :community
      t.string :household_name
      t.string :house_id
      t.string :farm_name
      t.string :farm_location
      t.string :livestock_keeping_reason
      t.string :years_since_farm_started
      t.boolean :sheep_kept
      t.integer :number_of_exotic_sheeps
      t.integer :number_of_mixed_sheeps
      t.integer :number_of_crossed_sheeps
      t.integer :number_of_local_sheeps
      t.boolean :goats_kept
      t.integer :number_of_exotic_goats
      t.integer :number_of_local_goats
      t.integer :number_of_crossed_goats
      t.integer :number_of_mixed_goats
      t.boolean :pigs_kept
      t.integer :number_of_local_pigs
      t.integer :number_of_exotic_pigs
      t.integer :number_of_crossed_pigs
      t.integer :number_of_mixed_pigs
      t.boolean :cattle_kept
      t.integer :number_of_local_cattle
      t.integer :number_of_exotic_cattle
      t.integer :number_of_mixed_cattle
      t.integer :number_of_crossed_cattle
      t.boolean :chicken_kept
      t.integer :number_of_local_chicken
      t.integer :number_of_exotic_chicken
      t.integer :number_of_crossed_chicken
      t.integer :number_of_mixed_chicken
      t.boolean :draught_animals_kept
      t.integer :number_of_donkeys
      t.integer :number_of_horses
      t.integer :number_of_bullocks
      t.integer :number_of_other_draught_animals
      t.string :cattle_housing_system
      t.string :goats_and_sheep_housing_system
      t.string :pigs_housing_system
      t.string :chicken_housing_system
      t.boolean :cattle_vaccinated_this_year
      t.string :type_of_cattle_vaccination, array: true, default: []
      t.string :period_of_cattle_vaccination
      t.boolean :sheep_and_goats_vaccinated_this_year
      t.string :type_of_sheep_and_goats_vaccination, array: true, default: []
      t.string :period_of_sheep_and_goats_vaccination
      t.string :source_of_feeding
      t.string :production_challenges, array: true, default: []
      t.boolean :own_a_phone
      t.string :type_of_phone
      t.string :phone_is_used_for, array: true, default: []
      t.boolean :use_mobile_money
      t.string :how_phone_is_charged
      t.string :how_airtime_is_topped_up, array: true, default: []
      t.string :action_taken_when_animal_is_sick
      t.string :action_taken_when_animal_care_info_is_needed
      t.string :how_disease_outbreak_is_known
      t.string :action_taken_when_disease_outbreak
      t.boolean :have_bank_account
      t.string :type_of_bank
      t.boolean :bank_saving
      t.string :type_of_bank_saving
      t.string :service_subscription, array: true, default: []
      t.references :user, foreign_key: true
      t.references :organization, foreign_key: true

      t.timestamps
    end
  end
end
