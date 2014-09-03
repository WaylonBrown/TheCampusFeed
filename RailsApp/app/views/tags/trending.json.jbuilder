json.array!(@tags) do |tag|
  json.extract! tag, :id#, :text#, :casedText#, :posts_count, :comments_count
  json.text tag.casedText
end
