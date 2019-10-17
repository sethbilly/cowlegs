class AddNamePlanTypeToPricingPlans < ActiveRecord::Migration[5.1]
  def change
    add_column :pricing_plans, :name, :string
    add_index :pricing_plans, :name, unique: true
    add_column :pricing_plans, :plan_type, :string
  end
end
