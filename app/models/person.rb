class Person < ActiveRecord::Base
	has_many :participants

	def name
		"#{firstname.gsub('_',' ')} #{lastname.gsub('_',' ')}" 
	end		

end
