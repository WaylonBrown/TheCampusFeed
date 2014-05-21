json.array!(@votes) do |vote|
  json.extract! vote, :id, :upvote, :votable_id, :votable_type
end
