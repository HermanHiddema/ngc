class CreateLeagues < ActiveRecord::Migration
	def change
		create_table :leagues do |t|
			t.string :name
			t.integer :order
			t.references :season, index: true

			t.timestamps
		end
	end
end
