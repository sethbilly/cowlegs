class CreateAnimalTags < ActiveRecord::Migration[5.1]
  def change
    create_table :animal_tags do |t|
      t.references :farmer, foreign_key: true
      t.string :bid_number
      t.string :tag_number
      t.integer :age
      t.string :sex
      t.text :notes
      t.string :breed

      t.timestamps
    end
  end
end
