class AddCardNumberToCards < ActiveRecord::Migration[5.1]
  def change
    add_column :cards, :card_number, :string, unique: true
  end
end
