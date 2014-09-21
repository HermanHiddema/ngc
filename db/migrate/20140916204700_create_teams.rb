class CreateTeams < ActiveRecord::Migration
	def change
		create_table :teams do |t|
			t.string :name
			t.string :abbrev
			t.references :club, index: true
			t.references :league, index: true
			t.references :captain, index: true

			t.timestamps
		end
	end
end
