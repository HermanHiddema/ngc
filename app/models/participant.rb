class Participant < ActiveRecord::Base
	belongs_to :club
	belongs_to :season
	belongs_to :person
	validates_presence_of :season
#	before_create :copy_person_attributes
	has_one :team_member
	has_many :black_games, class_name: 'Game', foreign_key: :black_id
	has_many :white_games, class_name: 'Game', foreign_key: :white_id

	def copy_person_attributes
		self.assign_attributes(person.attributes.with_indifferent_access.slice(:club_id, :firstname, :lastname, :rating, :egd_pin))
	end

	def name
		"#{firstname.gsub('_',' ')} #{lastname.gsub('_',' ')} (#{rating})" 
	end

	def fullname
		"#{firstname.gsub('_',' ')} #{lastname.gsub('_',' ')}"
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

	def rating_performance
		"#{(rating_change * 100).round(2)}%"
	end

	def rank=(value)
		value = value.to_i if value =~ /\A(\d+)\Z/
		self[:rank] = case value
		when 1..69 then value
		when /\A(\d)\s*(dan)?\s*p/i then $1.to_i + 60
		when /\Apro/i then 60
		when /\A(\d)\s*d/i then $1.to_i + 50
		when /\A([1-4]?\d)\s*k/i then 51 - $1.to_i
		else 0
		end
	end

	def rank
		case self[:rank]
		when 61..69 then "#{self[:rank] - 60}p"
		when 60 then 'pro'
		when 51..59 then "#{self[:rank] - 50}d"
		when 1..50 then "#{51 - self[:rank]}k"
		else ""
		end
	end
end
