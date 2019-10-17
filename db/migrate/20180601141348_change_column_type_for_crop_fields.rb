class ChangeColumnTypeForCropFields < ActiveRecord::Migration[5.1]
  def change
    change_column :farmers, :source_of_buying_fertilizer, "varchar[] USING (string_to_array(source_of_buying_fertilizer, ','))"
    change_column :farmers, :source_of_buying_seeds, "varchar[] USING (string_to_array(source_of_buying_seeds, ','))"
    change_column :farmers, :types_of_fertilizers, "varchar[] USING (string_to_array(types_of_fertilizers, ','))"
  end
end
