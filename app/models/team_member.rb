class TeamMember < ActiveRecord::Base
	belongs_to :team
	belongs_to :participant
	validates_presence_of :board_number, :participant
	delegate :name, :lastname, :firstname, :rating, to: :participant
end
