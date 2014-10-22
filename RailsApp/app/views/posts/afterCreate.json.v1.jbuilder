json.extract! @post, :id, :text, :score, :hidden, :created_at, :updated_at
json.vote_delta (@post.vote_delta + 1) #TODO fix ugly hack
json.initial_vote_id @post.votes[0].id
if(@post.image)
  json.image_uri @post.image.uri
end
