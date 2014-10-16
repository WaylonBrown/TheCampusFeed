json.extract! @post, :id, :text, :score, :vote_delta, :hidden, :created_at, :updated_at
if(@post.image)
  json.image_id @post.image.id
end
