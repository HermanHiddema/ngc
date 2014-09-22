class Venue < ActiveRecord::Base
	belongs_to :club
	has_many :matches
end
