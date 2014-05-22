json.array!(@tags) do |tag|
  json.extract! tag, :id, :text, :post_id
  json.post_count tag.posts.count
end
