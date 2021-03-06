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
				"%.2f" % (100 * p.rating_change),
				games.select { |game| "#{game[2]}" == '+' }.length,
				games.map { |game| "#{game[3]}#{game[2]}" },
				(games.length...width).map { "0=" }
			].flatten.map(&:to_s).join("\t")
		end
		teams_list = leagues.order(:order).map { |league| league.teams.sort_by(&:placement_criteria).reverse }.flatten + [OpenStruct.new(name: "Reserves")]
		results_list = player_list.each_slice(3).zip(teams_list).map { |p,t| [t ? "; #{t.name}" : nil, p] }.flatten.compact
	end

	def upsert_players(json_file)
		egd_json = File.read(json_file)
		egd_data = JSON.load(egd_json)
		egd_data['players'].each do |player|
			club = Club.find_by(abbrev: player['Club']) || Club.create(name: player['Club'], abbrev: player['Club'])
			person = Person.find_by(egd_pin: player['Pin_Player'])
			if person
				person.update_attributes(
					rating: player['Gor'].to_i,
					lastname: player['Real_Last_Name'],
					firstname: player['Real_Name'],
					club_id: club.id
				)
			else
				person = Person.create(
					egd_pin: player['Pin_Player'],
					rating: player['Gor'].to_i,
					lastname: player['Real_Last_Name'],
					firstname: player['Real_Name'],
					club_id: club.id
				)
			end
			participant = Participant.new(person_id: person.id, season_id: self.id, rank: player['Grade'])
			participant.copy_person_attributes
			participant.save
		end
	end

	def create_leagues(amount=5)
		amount.times do |n|
			create_league(n)
		end
	end

	def create_league(order)
		League.create(name: league_name_for_order(order), order: order, season: self)
	end

	def league_name_for_order(order)
		[
			'Hoofdklasse', 
			'Eerste klasse',
			'Tweede klasse',
			'Derde klasse',
			'Vierde klasse',
			'Vijfde klasse',
			'Zesde klasse',
			'Zevende klasse',
			'Achtste klasse',
			'Negende klasse',
			'Tiende klasse'
		][order]
	end

end
