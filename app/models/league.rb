class League < ActiveRecord::Base
	belongs_to :season
	has_many :teams
	has_many :matches

	def make_pairing(weeks=nil)
		weeks ||= 5.times.map { |i| Date.today.cweek + 2*(i+1) }
		pairing = round_robin_pairing(teams.to_a)
		pairing.each.with_index do |pairs,round|
			pairs.each do |home, away|
				venue = home.club.venues.first || Venue.first
				play_date = Date.commercial(Date.today.year, weeks[round], venue.playing_day)
				matches.create(black_team: home, white_team: away, venue: venue, playing_date: play_date, playing_time: venue.playing_time)
			end
		end
	end

	def drop_pairing
		matches.destroy_all
	end

	def round_robin_pairing(participants)
		return nil if participants.length < 3
		participants << nil if participants.length.odd?

		boards = participants.length / 2
		fixed  = participants.shift
		rounds = Array.new(participants.length) do |index|
			participants.unshift(fixed)
			round = boards.times.map do |board|
				index.odd? ? [participants[board], participants[-board-1]] : [participants[-board-1], participants[board]]
			end
			participants.shift
			participants.rotate!(-1)
			round
		end
	end

	def standings
		return @standings if @standings
		teams = self.teams.to_a.sort_by(&:placement_criteria).reverse
		table = Hash.new
		teams.product(teams).each do |team1, team2|
			table[team1.id] ||= {}
			table[team1.id][team2.id] = {}
		end
		matches.each do |match|
			table[match.black_team_id][match.white_team_id] = [
				match,
				match.played? ? match.black_points : nil,
				match.played? ? (match.black_score == 1 ? 'won' : 'lost') : 'unplayed',
				match.venue
			]
			table[match.white_team_id][match.black_team_id] = [
				match,
				match.played? ? match.white_points : nil,
				match.played? ? (match.white_score == 1 ? 'won' : 'lost') : 'unplayed',
				match.venue
			]
		end
		@standings = table
	end
end
