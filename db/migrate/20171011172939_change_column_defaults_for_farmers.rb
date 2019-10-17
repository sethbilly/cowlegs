class ChangeColumnDefaultsForFarmers < ActiveRecord::Migration[5.1]
  def change
  	change_column_default :farmers, :sheep_kept, false
  	change_column_default :farmers, :goats_kept, false
  	change_column_default :farmers, :pigs_kept, false
  	change_column_default :farmers, :cattle_kept, false
  	change_column_default :farmers, :chicken_kept, false
  	change_column_default :farmers, :draught_animals_kept, false
  	change_column_default :farmers, :cattle_vaccinated_this_year, false
  	change_column_default :farmers, :sheep_and_goats_vaccinated_this_year, false
  	change_column_default :farmers, :own_a_phone, false
  	change_column_default :farmers, :use_mobile_money, false
  	change_column_default :farmers, :have_bank_account, false
  	change_column_default :farmers, :bank_saving, false
  end
end
