json.array!(@tags) do |tag|
  json.extract! tag, :id, :text, :posts_count
end
