json.array!(@comments) do |comment|
  json.extract! comment, :id, :text, :score, :post_id
end
