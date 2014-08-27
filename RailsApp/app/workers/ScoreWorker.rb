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

  def perform
    Post.all.each{ |post|
      upvotes = post.votes.where({upvote: true}).count
      allvotes = post.votes.count


      #result = ci_lower_bound(upvotes, allvotes, @@confidence_interval)

      #post.score = result * 10000
      post.score = hot(upvotes, allvotes, post.created_at)
      post.save
    }
  end
end
