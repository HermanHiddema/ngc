class CreateVenues < ActiveRecord::Migration
	def change
		create_table :venues do |t|
			t.references :club, index: true
			t.string :name
			t.integer :playing_day
			t.string :playing_time
			t.text :info

			t.timestamps
		end
	end
end
