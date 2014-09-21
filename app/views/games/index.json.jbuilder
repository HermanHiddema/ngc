json.array!(@games) do |game|
  json.extract! game, :id, :match_id, :black_id, :white_id, :black_points, :white_points, :reason
  json.url game_url(game, format: :json)
end
