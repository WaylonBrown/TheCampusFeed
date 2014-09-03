class PostScoreWorker 
  include Sidekiq::Worker

  def score(up, total)
    down = total - up
    return up - down
  end

  def hot(up, total, date)
      s = score(up, total)
      order = Math.log10([s.abs, 1].max)
      sign = 0

      if s > 0
        sign = 1
      elsif s < 0
        sign = -1
      end

      seconds = date.to_time.to_i - 1134028003
      return order + sign * seconds
  end

  def perform(post_id)

    post = Post.find(post_id)
    upvotes = post.votes.where({upvote: true}).count
    allvotes = post.votes.count
    downvotes = allvotes - upvotes

    post.score = hot(upvotes, allvotes, post.created_at)
    post.save

  end
end
