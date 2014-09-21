json.array!(@venues) do |venue|
  json.extract! venue, :id, :club_id, :name, :playing_day, :playing_time, :info
  json.url venue_url(venue, format: :json)
end
