class AddBasisForDiagnosisToCases < ActiveRecord::Migration[5.1]
  def change
    add_column :cases, :basis_for_diagnosis, :string, array: true, default: []
  end
end
