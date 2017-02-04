class Game < ActiveRecord::Base
	belongs_to :match
	belongs_to :black_player, class_name: 'Participant', foreign_key: :black_id
	belongs_to :white_player, class_name: 'Participant', foreign_key: :white_id

	delegate :rating, to: :black_player, prefix: :black
	delegate :rating, to: :white_player, prefix: :white

	scope :played, -> { where.not(black_points: nil, white_points: nil) }

	def played?
		@played ||= black_points.present? && white_points.present?
	end

	def unplayed?
		!played?
	end

	def forfeit?
		reason?
	end

	def swap_colors
		self.black_points, self.white_points = white_points, black_points
		self.black_player, self.white_player = white_player, black_player
		save
	end

	def color_of(player)
		return :black if black_player.id == player.id
		return :white if white_player.id == player.id
		nil
	end

	def result
		@result ||= case black_points
			when 0 then '0'
			when 1 then '½'
			when 2 then '1'
			else '?'
		end + '-' + case white_points
			when 0 then '0'
			when 1 then '½'
			when 2 then '1'
			else '?'
		end + "#{reason}"
	end

	def result=(value)
		if value =~ /^(.)-(.)(!?)/
			self.black_points = case $1
				when '0' then 0
				when '½' then 1
				when '1' then 2
				else nil
			end
			self.white_points = case $2
				when '0' then 0
				when '½' then 1
				when '1' then 2
				else nil
			end
			self.reason = ($3 == '!') ? '!' : nil
		else
			self.black_points = nil
			self.white_points = nil
			self.reason = nil
		end
		@result = nil
		@played = nil
	end

	def black_score
		return 0 if black_points.nil? || white_points.nil?
		@black_score ||= case
		when black_points > white_points then 1
		when white_points > black_points then 0
		else 0.5
		end
	end

	def white_score
		return 0 if black_points.nil? || white_points.nil?
		@white_score ||= case
		when white_points > black_points then 1
		when black_points > white_points then 0
		else 0.5
		end
	end

	def black_result
		case
		when unplayed? then '?'
		when black_score == 1 then '+'
		when black_score == 0 then '-'
		else '='
		end
	end

	def white_result
		case
		when unplayed? then '?'
		when white_score == 1 then '+'
		when white_score == 0 then '-'
		else '='
		end
	end

	def black_rating_change
		@black_rating_change ||= (played? && !forfeit?) ? black_score - black_score_exp : 0
	end

	def white_rating_change
		@white_rating_change ||= (played? && !forfeit?) ? white_score - white_score_exp : 0
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
