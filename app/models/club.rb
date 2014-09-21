class Club < ActiveRecord::Base
	has_many :participants
	has_many :teams
	has_many :venues
    belongs_to :contact_person, class_name: 'Person'
	validates_presence_of :name


end
