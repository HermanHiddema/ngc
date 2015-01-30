admin = User.create(email: 'herman@hiddema.nl', password: 'password123')
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