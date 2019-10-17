class ChangeColumnDefaultForHaveInternet < ActiveRecord::Migration[5.1]
  def change
  	change_column_default :farmers, :have_internet, false
  end
end
