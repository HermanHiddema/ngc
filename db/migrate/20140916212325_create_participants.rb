class CreateParticipants < ActiveRecord::Migration
	def change
		create_table :participants do |t|
			t.string :firstname
			t.string :lastname
			t.integer :rating
			t.string :egd_pin
			t.references :person, index: true
			t.references :club, index: true
			t.references :season, index: true

			t.timestamps
		end
	end
end
