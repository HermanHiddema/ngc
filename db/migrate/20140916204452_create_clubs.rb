class CreateClubs < ActiveRecord::Migration
	def change
		create_table :clubs do |t|
			t.string :name
			t.string :abbrev
			t.string :website
			t.text :info
			t.references :contact_person, index: true

			t.timestamps
		end
	end
end
