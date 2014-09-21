class CreateTeamMembers < ActiveRecord::Migration
	def change
		create_table :team_members do |t|
			t.references :participant, index: true
			t.references :team, index: true
			t.integer :board_number
			t.timestamps
		end
	end
end
