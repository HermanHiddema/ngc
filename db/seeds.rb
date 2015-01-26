require 'csv'
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
admin = User.create(email: 'herman@hiddema.nl', password: 'brood123#')
#admin.confirm!
season = Season.create(name: 'Najaar 2014')
groningen = Club.create(name: 'Groningen', abbrev: 'Gron')
Venue.create(name: 'Zwolle', club: groningen, playing_day: 3, playing_time: '20:00')
utrecht   = Club.create(name: 'Utrecht', abbrev: 'Utre')
Venue.create(name: 'Utrecht', club: utrecht, playing_day: 1, playing_time: '19:45')
den_haag  = Club.create(name: 'Den Haag', abbrev: 'DHaa')
Venue.create(name: 'Den Haag', club: den_haag, playing_day: 3, playing_time: '19:45')
leiden    = Club.create(name: 'Leiden', abbrev: 'Leid')
Venue.create(name: 'Leiden (donderdag)', club: leiden, playing_day: 4, playing_time: '19:45')
arnhem    = Club.create(name: 'Arnhem', abbrev: 'Arnh')
Venue.create(name: 'Arnhem', club: arnhem, playing_day: 1, playing_time: '19:45')
nijmegen  = Club.create(name: 'Nijmegen', abbrev: 'Nijm')
Venue.create(name: 'Nijmegen', club: nijmegen, playing_day: 1, playing_time: '19:45')
almere    = Club.create(name: 'Almere', abbrev: 'Alme')
Venue.create(name: 'Almere', club: almere, playing_day: 3, playing_time: '19:45')
amstelveen= Club.create(name: 'Amstelveen', abbrev: 'Amvn')
Venue.create(name: 'Amstelveen', club: amstelveen, playing_day: 2, playing_time: '19:45')
amsterdam = Club.create(name: 'Amsterdam', abbrev: 'Amst')
Venue.create(name: 'Amsterdam', club: amsterdam, playing_day: 3, playing_time: '19:45')
alphen    = Club.create(name: 'Alph/Gouda/Zoet', abbrev: 'Alph')
Venue.create(name: 'Alphen', club: alphen, playing_day: 2, playing_time: '19:45')
Venue.create(name: 'Gouda', club: alphen, playing_day: 2, playing_time: '19:45')
Venue.create(name: 'Zoetermeer', club: alphen, playing_day: 2, playing_time: '19:45')

person_csv = CSV.read(Rails.root.join('personen.csv'))
person_csv.each do |player|
	club = Club.find_by(abbrev: player[4]) || Club.create(name: player[4], abbrev: player[4])
	person = Person.create(
		lastname: player[3],
		firstname: player[2],
		rating: player[5].to_i,
		email: player[7],
		email2: player[8],
		phone: player[9],
		phone2: player[10],
		club_id: club.id,
	)
	Participant.create(person: person, season: season)
end


egd_json = File.read(Rails.root.join('netherlands-2015-1.json'))
egd_data = JSON.load(egd_json) 
egd_data['players'].each do |player|
  club = Club.find_by(abbrev: player['Club']) || Club.create(name: player['Club'], abbrev: player['Club'])
  person = Person.find_by(lastname: player['Real_Last_Name'], firstname: player['Real_Name'])
  if person
    person.update_attributes(
      egd_pin: player['Pin_player'],
      rating: player['Gor'].to_i,
      club_id: club.id
    )
  else
    person = Person.create(
      egd_pin: player['Pin_player'],
      rating: player['Gor'].to_i,
      lastname: player['Real_Last_Name'],
      firstname: player['Real_Name'],
      club_id: club.id
    )
  end
  participant = Participant.new(person_id: person.id, season_id: 2)
  participant.copy_person_attributes
  participant.save
end

leagues = [
	nil,
	League.create(name: 'Hoofdklasse', order: 1, season: season),
	League.create(name: 'Eerste klasse', order: 2, season: season),
	League.create(name: 'Tweede klasse', order: 3, season: season),
	League.create(name: 'Derde klasse', order: 4, season: season),
	League.create(name: 'Vierde klasse', order: 5, season: season)
]

team_csv = CSV.read(Rails.root.join('teams.csv'))
team_csv.each do |team|
	league = leagues[team[2].to_i]
	club = Club.find_by(name: team[1]) || Club.find_by(abbrev: team[1][0..3]) || Club.create(name: team[1], abbrev: team[1][0..3])
	Team.create(name: team[0], abbrev: team[0][0..2]+team[0][-1], club: club, league: league,
		team_members_attributes: [
	 		{ board_number: 1, participant_id: Participant.find_by(firstname: team[3], lastname: team[4]).id },
	 		{ board_number: 2, participant_id: Participant.find_by(firstname: team[6], lastname: team[7]).id },
	 		{ board_number: 3, participant_id: Participant.find_by(firstname: team[9], lastname: team[10]).id }
		],
		captain_id: Person.find_by(firstname: team[12], lastname: team[13]).id
	)
end

rooster_csv = CSV.read(Rails.root.join('rooster.csv'))
rooster_csv.each do |match|
	league = League.find_by(order: match[5].to_i)
	home = Team.find_by(name: match[6])
	away = Team.find_by(name: match[7])
	venue = Venue.find_by(name: match[8])
	play_day = ['4','5','6'].include?(match[12]) ? 7 : venue.playing_day
	play_time = ['4','5','6'].include?(match[12]) ? match[12].to_i * 3 - 2 : venue.playing_time
	play_date = Date.commercial(2014, match[11].to_i, play_day)
	league.matches.create(black_team: home, white_team: away, venue: venue, playing_date: play_date, playing_time: play_time)
end