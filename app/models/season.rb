class Season < ActiveRecord::Base
	has_many :leagues
	has_many :teams, through: :leagues
	has_many :matches, through: :leagues
end
