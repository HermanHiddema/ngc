json.array!(@participants) do |participant|
  json.extract! participant, :id, :firstname, :lastname, :rating, :egd_pin, :club_id, :season_id
  json.url participant_url(participant, format: :json)
end
