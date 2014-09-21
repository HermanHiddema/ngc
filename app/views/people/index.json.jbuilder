json.array!(@people) do |person|
  json.extract! person, :id, :firstname, :lastname, :egd_pin, :email
  json.url person_url(person, format: :json)
end
