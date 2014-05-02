json.array!(@comments) do |comment|
  json.extract! comment, :id, :text, :score
  json.url comment_url(comment, format: :json)
end
