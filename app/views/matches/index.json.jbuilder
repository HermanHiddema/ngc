json.array!(@matches) do |match|
  json.extract! match, :id, :league_id
  json.url match_url(match, format: :json)
end
