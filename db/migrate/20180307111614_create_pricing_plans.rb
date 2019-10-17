class CreatePricingPlans < ActiveRecord::Migration[5.1]
  def change
    create_table :pricing_plans do |t|
      t.decimal :price, precision: 8, scale: 2

      t.timestamps
    end
  end
end
