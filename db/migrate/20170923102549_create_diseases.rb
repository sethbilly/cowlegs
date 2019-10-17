class CreateDiseases < ActiveRecord::Migration[5.1]
  def change
    create_table :diseases do |t|
      t.string :name

      t.timestamps
    end
    add_index :diseases, :name, unique: true
  end
end
