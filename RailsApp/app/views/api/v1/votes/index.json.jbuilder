json.array!(@votes) do |vote|
  json.extract! vote, :id, :upvote, :votable_id, :votable_type
  json.url api_v1_vote_url(vote, format: :json)
end
