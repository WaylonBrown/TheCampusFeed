json.array!(@users) do |user|
  json.extract! user, :id, :token, :secret
  json.url user_url(user, format: :json)
end
