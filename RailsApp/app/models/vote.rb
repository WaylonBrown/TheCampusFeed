class Vote < ActiveRecord::Base
  belongs_to :votable, polymorphic: true

  after_create :increment_vote_delta

  def increment_vote_delta
    if votable
      votable.vote_delta += self.upvote ? 1 : -1;
      votable.save
    end
  end

  after_destroy :decrement_vote_delta

  def decrement_vote_delta
    if votable
      votable.vote_delta -= self.upvote ? 1 : -1;
      votable.save
    end
  end
  
end
