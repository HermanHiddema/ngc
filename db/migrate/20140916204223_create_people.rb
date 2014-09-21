class CreatePeople < ActiveRecord::Migration
	def change
		create_table :people do |t|
			t.string :firstname
			t.string :lastname
			t.string :egd_pin
			t.integer :rating
			t.references :club, index: true
			t.string :email
			t.string :email2
			t.string :phone
			t.string :phone2

			t.timestamps
		end
	end
end
