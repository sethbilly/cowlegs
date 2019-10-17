class RenameNumberOfSheepColumns < ActiveRecord::Migration[5.1]
  def change
  	rename_column :farmers, :number_of_exotic_sheeps, :number_of_exotic_sheep
  	rename_column :farmers, :number_of_mixed_sheeps, :number_of_mixed_sheep
  	rename_column :farmers, :number_of_crossed_sheeps, :number_of_crossed_sheep
  	rename_column :farmers, :number_of_local_sheeps, :number_of_local_sheep
  end
end