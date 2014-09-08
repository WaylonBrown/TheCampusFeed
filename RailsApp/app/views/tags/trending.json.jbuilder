json.array!(@tags) do |tag|
  #json.extract! tag, :text, :posts_count
  json.text tag[0]
  json.posts_count tag[1]
end
