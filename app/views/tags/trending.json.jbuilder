json.array!(@tags) do |tag|
  json.extract! tag, :id, :text, :post_id
  json.url tag_url(tag, format: :json)
  json.post_count tag.posts.count
end
