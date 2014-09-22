class Game < ActiveRecord::Base
	belongs_to :match
	belongs_to :black_player, class_name: 'Participant', foreign_key: :black_id
	belongs_to :white_player, class_name: 'Participant', foreign_key: :white_id

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
			reason = '!'
		else
			reason = nil
		end
	end
end
