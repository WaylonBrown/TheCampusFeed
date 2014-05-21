json.array!(@colleges) do |college|
  json.extract! college, :id, :name, :lat, :lon
end
