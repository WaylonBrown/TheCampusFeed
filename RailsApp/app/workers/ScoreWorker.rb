require 'statistics2'

class ScoreWorker 
  include Sidekiq::Worker

  @@confidence_interval = 0.95

  def ci_lower_bound(pos, n, confidence)
    if n == 0
        return 0
    end
    z = Statistics2.pnormaldist(1-(1-confidence)/2)
    phat = 1.0*pos/n
    (phat + z*z/(2*n) - z * Math.sqrt((phat*(1-phat)+z*z/(4*n))/n))/(1+z*z/n)
  end

  def perform
    Post.all.each{ |post|
      upvotes = post.votes.where({upvote: true}).count
      allvotes = post.votes.count

      result = ci_lower_bound(upvotes, allvotes, @@confidence_interval)
      p result
      post.score = result * 10000
      p post
      post.save
    }
  end
end
