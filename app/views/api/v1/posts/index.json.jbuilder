json.array!(@posts) do |post|
  json.extract! post, :id, :text, :score, :lat, :lon
  json.url post_url(post, format: :json)
end
