json.array!(@tags) do |tag|
  json.extract! tag, :id, :text, :post_id
end
