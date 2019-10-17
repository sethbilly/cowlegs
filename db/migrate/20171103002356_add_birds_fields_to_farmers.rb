class AddBirdsFieldsToFarmers < ActiveRecord::Migration[5.1]
  def change
    add_column :farmers, :birds_vaccinated_this_year, :boolean
    add_column :farmers, :period_of_birds_vaccination, :string
    add_column :farmers, :type_of_birds_vaccination, :string, array: true, default: []
    add_column :farmers, :have_internet, :boolean
  end
end
