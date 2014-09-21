class CreateMatches < ActiveRecord::Migration
	def change
		create_table :matches do |t|
			t.references :league, index: true
			t.references :black_team, index: true
			t.references :white_team, index: true
			t.date :playing_date
			t.string :playing_time
			t.references :venue, index: true

			t.timestamps
		end
	end
end
