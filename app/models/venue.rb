class Venue < ActiveRecord::Base
	belongs_to :club
	has_many :matches

	validates_presence_of :name, :address, :city, :club, :playing_time, :playing_day

end
