class Participant < ActiveRecord::Base
	belongs_to :club
	belongs_to :season
	belongs_to :person
	validates_presence_of :season
	before_create :copy_person_attributes
	has_one :team_member
	has_many :black_games, class_name: 'Game', foreign_key: :black_id
	has_many :white_games, class_name: 'Game', foreign_key: :white_id

	def copy_person_attributes
		self.assign_attributes(person.attributes.with_indifferent_access.slice(:club_id, :firstname, :lastname, :rating, :egd_pin))
	end

	def name
		"#{firstname.gsub('_',' ')} #{lastname.gsub('_',' ')} (#{rating})" 
	end		

	def games
		Game.where('black_id = ? OR white_id = ?', self.id, self.id)
	end

	def played_games
		games.where('black_points IS NOT NULL')
	end

	def rating_change
		black_games.played.map(&:black_rating_change).sum + white_games.played.map(&:white_rating_change).sum
	end

end
