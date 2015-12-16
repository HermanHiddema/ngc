class Season < ActiveRecord::Base
	has_many :leagues
	has_many :teams, through: :leagues
	has_many :matches, through: :leagues
	has_many :participants
	has_many :games, through: :matches

	before_validation :update_slug

	def update_slug
		self.slug = name.gsub(/[^A-z0-9]/,'-').downcase
	end

	def results
		res = Hash.new
		leagues.order(:order).includes(:teams).each do |league|
			league.teams.sort_by(&:placement_criteria).reverse.each do |team|
				team.team_members.includes(:participant).order(:board_number).map(&:participant).each do |participant|
					res[participant.id] ||= Array.new
				end
			end
		end
		participants.select { |p| p.played_games.length > 0 }.sort_by { |p| p.rating_change || 0 }.reverse.map { |p| res[p.id] ||= Array.new }
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
			p = participants.find(pid)
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
		teams_list = leagues.order(:order).map { |league| league.teams.sort_by(&:placement_criteria).reverse }.flatten + [OpenStruct.new(name: "Reserves")]
		results_list = player_list.each_slice(3).zip(teams_list).map { |p,t| [t ? "# #{t.name}" : nil, p] }.flatten.compact
	end
end
