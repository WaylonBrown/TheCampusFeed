json.array!(@flags) do |flag|
  json.extract! flag, :id, :flaggable_id
  json.url flag_url(flag, format: :json)
end
