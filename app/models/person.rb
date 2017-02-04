class Person < ActiveRecord::Base
	has_many :participants

	def name
		"#{firstname.gsub('_',' ')} #{lastname.gsub('_',' ')}" 
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

	def absorb(other_person)
		# TODO: for merging duplicates
	end
end
