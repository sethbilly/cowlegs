class CreateOrganizations < ActiveRecord::Migration[5.1]
  def change
    create_table :organizations do |t|
    	t.string :name
    	t.string :designation
    	t.string :postal_address
    	t.integer :number_of_staff
    	t.jsonb :location, null: false, default: '{}'
    	t.text :description
    	
      t.timestamps
    end
  end
end
