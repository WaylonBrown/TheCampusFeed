json.array!(@posts) do |post|
  json.extract! post, :id, :text, :score, :vote_delta, :hidden, :created_at, :updated_at, :college_id, :comment_count, :vote_delta
  if(post.image)
    json.image_uri post.image.uri
  end
end
