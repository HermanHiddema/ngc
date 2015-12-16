class League < ActiveRecord::Base
	belongs_to :season
	has_many :teams
	has_many :matches
	has_many :games, through: :matches

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
		participants = participants.dup
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

	def direct_comparison
		teams.product(teams).each do |team1, team2|
			table[team1.id] ||= {}
			table[team1.id][team2.id] = if team1.score == team2.score && team1.points == team2.points
				0
			else
				nil
			end
		end
		matches.each do |match|
			if table[match.black_team_id][match.white_team_id]
				table[match.black_team_id][match.white_team_id] = [match.black_score, match.black_points]
				table[match.white_team_id][match.black_team_id] = [match.white_score, match.white_points]
			end
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

	def team_ordered_players

	end

	def full_results
		teams = self.teams.to_a.sort_by(&:placement_criteria).reverse
		pairing = round_robin_pairing(teams)
		table = Hash.new
		teams.each do |team|
			table[team.id] = Hash.new
			table[team.id][:matches] = Hash.new
		end
		pairing.each do |round|
			round.each do |team1, team2|
				match = Match.find_by_teams(team1, team2)
				table[team1.id][:matches][match.id] = match
				table[team2.id][:matches][match.id] = match
			end
		end
		teams.each do |team|
			players = (team.black_matches.map(&:games).map(&:black_player).map(&:id) + team.white_matches.map(&:games).map(&:white_player).map(&:id)).flatten.uniq
		end
	end

	def results
		res = Hash.new
		teams.sort_by(&:placement_criteria).reverse.each do |team|
			team.team_members.includes(:participant).order(:board_number).map(&:participant).each do |participant|
				res[participant.id] ||= Array.new
			end
		end
		games.each do |game|
			res[game.black_id] ||= Array.new
			res[game.white_id] ||= Array.new
			free = 0
			free += 1 while res[game.black_id][free] || res[game.white_id][free]
			res[game.black_id][free] = [game, game.white_id, game.black_result]
			res[game.white_id][free] = [game, game.black_id, game.white_result]
		end
		res.each_with_index do |(pid,games), i|
			games.each_with_index do |game, j|
				if game.nil?
					res[pid][j] = [nil, nil, '=', 0]
				elsif game[0].forfeit?
					res[game[1]][j] << 0
				else
					res[game[1]][j] << i+1
				end
			end
		end
		width = res.map { |k,v| v.length }.max
		player_list = res.map.with_index do |(pid,games), i|
			p = Participant.find(pid)
			[
				i+1, 
				"%-30s" % [p.lastname, p.firstname].map(&:strip).join(' '),
				p.rank,
				"NL",
				p.club.abbrev,
				p.team_member.present? ? p.team_member.board_number : 0,
				(100 * p.rating_change).to_s[0..5],
				games.select { |game| "#{game[2]}" == '+' }.length,
				games.map { |game| "#{game[3]}#{game[2]}" },
				(games.length...width).map { "0=" }
			].flatten.map(&:to_s).join("\t")
		end
		teams_list = teams.sort_by(&:placement_criteria).reverse + [OpenStruct.new(name: "Reserves")]
		results_list = player_list.each_slice(3).zip(teams_list).map { |p,t| [t ? "; #{t.name}" : nil, p] }.flatten.compact
	end


end
