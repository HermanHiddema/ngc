json.array!(@leagues) do |league|
  json.extract! league, :id, :name, :order, :season_id
  json.url league_url(league, format: :json)
end
