json.array!(@posts) do |post|
  json.extract! post, :id, :text, :score, :lat, :lon
  json.url api_v1_post_url(post, format: :json)
end
