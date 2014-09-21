json.array!(@clubs) do |club|
  json.extract! club, :id, :name, :abbrev
  json.url club_url(club, format: :json)
end
