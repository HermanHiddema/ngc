require 'open-uri'

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

	# Example entry of the EGD json for a player
	# {
	# 	"Pin_Player":"10537560",
	# 	"AGAID":"0",
	# 	"Last_Name":"Aaij",
	# 	"Name":"Rene",
	# 	"Country_Code":"NL",
	# 	"Club":"Gron",
	# 	"Grade":"4d",
	# 	"Grade_n":"33",
	# 	"EGF_Placement":"175",
	# 	"Gor":"2402",
	# 	"DGor":"0",
	# 	"Proposed_Grade":"",
	# 	"Tot_Tournaments":"84",
	# 	"Last_Appearance":"T170114F",
	# 	"Elab_Date":"2009-04-03",
	# 	"Hidden_History":"0",
	# 	"Real_Last_Name":"Aaij",
	# 	"Real_Name":"Rene"
	# },

	def self.update_all_from_egd
		open('http://www.europeangodatabase.eu/EGD/GetPlayerDataByData.php?lastname=%&country=nl') do |egd_json|
			egd_data = JSON.load(egd_json)
			egd_data['players'].map do |player|
				club = Club.find_or_create_by(abbrev: player['Club'])

				person = Person.find_or_build_by(egd_pin: player['Pin_Player'])
				person.update_attributes(
					rating: player['Gor'].to_i,
					rank: player['Grade'],
					lastname: player['Real_Last_Name'],
					firstname: player['Real_Name'],
					club_id: club.id
				)
				person.save
			end
		end
	end
end
