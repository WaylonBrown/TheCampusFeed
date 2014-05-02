json.array!(@colleges) do |college|
  json.extract! college, :id, :name, :state, :lat, :lon
  json.url college_url(college, format: :json)
end
