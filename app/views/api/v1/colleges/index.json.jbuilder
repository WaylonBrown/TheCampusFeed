json.array!(@colleges) do |college|
  json.extract! college, :id, :name, :lat, :lon, :size
  json.url api_v1_college_url(college, format: :json)
end
