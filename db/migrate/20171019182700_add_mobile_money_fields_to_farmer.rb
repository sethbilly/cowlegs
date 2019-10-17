class AddMobileMoneyFieldsToFarmer < ActiveRecord::Migration[5.1]
  def change
    add_column :farmers, :last_use_of_mobile_money, :string
    add_column :farmers, :why_not_use_mobile_money, :string
  end
end
