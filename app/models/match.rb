class Match < ActiveRecord::Base
	belongs_to :league
	belongs_to :venue

	belongs_to :black_team, class_name: 'Team'
	belongs_to :white_team, class_name: 'Team'
	has_many :games

	accepts_nested_attributes_for :games

	after_create :fill_games

	def fill_games
		black_team.team_members.each do |black|
			white = white_team.team_members.find_by(board_number: black.board_number)
			if white
				games.create(board_number: black.board_number, black_player: black.participant, white_player: white.participant)
			end
		end
	end

	def self.find_by_teams(team1, team2)
		Match.find_by_team_ids(team1.id, team2.id) if team1 && team2
	end

	def self.find_by_team_ids(team1_id, team2_id)
		Match.find_by(black_team_id: team1_id, white_team_id: team2_id) || Match.find_by(black_team_id: team2_id, white_team_id: team1_id)
	end

	def opponent(team)
		@opponent ||= case team.id
		when black_team.id then white_team
		when white_team.id then black_team
		else nil
		end
	end

	def played?
		@played ||= games.map(&:played?).any?
	end

	def black_score
		if played?
			@black_score ||= black_points > white_points ? 1 : 0
		end
	end

	def white_score
		if played?
			@white_score ||= white_points > black_points ? 1 : 0
		end
	end

	def black_points
		if played?
			@black_points ||= games.sum(:black_points) / 2
		end
	end

	def white_points
		if played?
			@white_points ||= games.sum(:white_points) / 2
		end
	end

	def result
		@result ||= "#{black_points || '?'}-#{white_points || '?'}"
	end

end
