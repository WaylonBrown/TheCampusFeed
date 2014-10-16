json.extract! @post, :id, :text, :score, :vote_delta, :hidden, :created_at, :updated_at
json.initial_vote_id @post.votes[0].id
if(@post.image)
  json.image_id @post.image.id
end
