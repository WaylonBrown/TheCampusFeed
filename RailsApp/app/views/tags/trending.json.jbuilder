json.array!(@tags) do |tag|
  json.extract! tag, :id, :text
  json.post_count tag.posts.count
end
