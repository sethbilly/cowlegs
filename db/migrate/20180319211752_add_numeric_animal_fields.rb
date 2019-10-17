class AddNumericAnimalFields < ActiveRecord::Migration[5.1]
  def change
  	add_column :farmers, :number_of_sheep, :integer
  	add_column :farmers, :number_of_goats, :integer
  	add_column :farmers, :number_of_cattle, :integer
  	add_column :farmers, :number_of_chicken, :integer
  	add_column :farmers, :number_of_pigs, :integer
  end
end
