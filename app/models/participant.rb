class Participant < ActiveRecord::Base
	belongs_to :club
	belongs_to :season
	belongs_to :person
	validates_presence_of :person, :season
	before_create :copy_person_attributes

	def copy_person_attributes
		self.assign_attributes(person.attributes.with_indifferent_access.slice(:club_id, :firstname, :lastname, :rating, :egd_pin))
	end

	def name
		"#{firstname.gsub('_',' ')} #{lastname.gsub('_',' ')} (#{rating})" 
	end		

end
