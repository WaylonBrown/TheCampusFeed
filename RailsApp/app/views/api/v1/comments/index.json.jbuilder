json.array!(@comments) do |comment|
  json.extract! comment, :id, :text, :score
  json.url api_v1_comment_url(comment, format: :json)
end
