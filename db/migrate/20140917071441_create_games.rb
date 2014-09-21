class CreateGames < ActiveRecord::Migration
	def change
		create_table :games do |t|
			t.references :match, index: true
			t.references :black, index: true
			t.references :white, index: true
			t.integer :black_points
			t.integer :white_points
			t.string :reason
			t.integer :board_number
			t.timestamps
		end
	end
end
