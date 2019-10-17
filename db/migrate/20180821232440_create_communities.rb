class CreateCommunities < ActiveRecord::Migration[5.1]
  def change
    create_table :communities do |t|
      t.string :address
      t.decimal :lat, precision: 10, scale: 6
      t.decimal :lng, precision: 10, scale: 6
      t.references :zone, foreign_key: true

      t.timestamps
    end
    add_index :communities, :address, unique: true
  end
end
