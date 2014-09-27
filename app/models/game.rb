class Game < ActiveRecord::Base
	belongs_to :match
	belongs_to :black_player, class_name: 'Participant', foreign_key: :black_id
	belongs_to :white_player, class_name: 'Participant', foreign_key: :white_id

	delegate :rating, to: :black_player, prefix: :black
	delegate :rating, to: :white_player, prefix: :white

	scope :played, ->{ where('black_points IS NOT NULL')}

	def played?
		@played ||= !black_points.nil? && !white_points.nil?
	end

	def unplayed?
		!played?
	end

	def result
		@result ||= if black_points == 1 && white_points == 1
			"jigo"
		elsif black_points.nil? && white_points.nil? 
			"?-?"
		else
			"#{black_points/2}-#{white_points/2}#{reason}"
		end
	end

	def result=(value)
		case value
		when /([01])-([01])/
			self.black_points = $1.to_i * 2
			self.white_points = $2.to_i * 2
		else
			self.black_points = nil
			self.white_points = nil
		end
		if value.include? '!'
			self.reason = '!'
		else
			self.reason = nil
		end
		@result = nil
		@played = nil
	end

	def black_score
		@black_score ||= case
		when black_points > white_points then 1
		when white_points > black_points then 0
		else 0.5
		end
	end

	def white_score
		@white_score ||= case
		when white_points > black_points then 1
		when black_points > white_points then 0
		else 0.5
		end
	end

	def black_rating_change
		@black_rating_change ||= played? ? black_score - black_score_exp : 0
	end

	def white_rating_change
		@white_rating_change ||= played? ? white_score - white_score_exp : 0
	end

	def black_score_exp
		@black_score_exp ||= score_exp(white_rating-black_rating)
	end

	def white_score_exp
		@white_score_exp ||= score_exp(black_rating-white_rating)
	end

	def score_exp(rd)
		weaker_rating = [black_player.rating, white_player.rating].min
		a = 200 - (weaker_rating-100)/20.0 # a from the EGF GoR formula
		1.0 / (Math.exp(rd/a) + 1)
	end
end
