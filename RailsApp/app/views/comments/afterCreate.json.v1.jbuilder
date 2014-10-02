json.extract! @comment, :id, :text, :score, :post_id, :created_at, :updated_at
json.initial_vote_id @comment.votes[0].id
