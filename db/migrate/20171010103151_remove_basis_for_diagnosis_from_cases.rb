class RemoveBasisForDiagnosisFromCases < ActiveRecord::Migration[5.1]
  def change
    remove_column :cases, :basis_for_diagnosis, :string
  end
end
