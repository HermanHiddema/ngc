class Team < ActiveRecord::Base
	belongs_to :club
	belongs_to :league
	belongs_to :captain, class_name: 'Person'

	has_many :black_matches, class_name: 'Match', foreign_key: :black_team_id
	has_many :white_matches, class_name: 'Match', foreign_key: :white_team_id
	has_many :team_members
	has_many :participants, through: :team_members
	accepts_nested_attributes_for :team_members

	delegate :name, to: :captain, prefix: true

	def matches
		@matches ||= Match.where('black_team_id = ? OR white_team_id = ?', self.id, self.id)
	end

	def score
		@score ||= (black_matches.map(&:black_score) + white_matches.map(&:white_score)).compact.sum
	end

	def points
		@points ||= (black_matches.map(&:black_points) + white_matches.map(&:white_points)).compact.sum
	end

	def unplayed_matches
		matches.reject(&:played?).length
	end

	def placement_criteria
		[score, points, unplayed_matches]
	end

end
