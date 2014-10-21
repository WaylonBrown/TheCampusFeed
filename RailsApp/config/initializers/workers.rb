require 'CommentScoreWorker'
require 'PostScoreWorker'

unless File.basename($0) == "rake"
  Thread.new do
    while true
      @week_ago = Time.now - 1.week
      #logger.info "Starting PostScoreWorker cycle"
      sleep 10
      ActiveRecord::Base.connection_pool.with_connection{|con|
        Post.find_each(:conditions => "created_at > #{@week_ago.to_i}") do |post|
          PostScoreWorker.perform_async post.id
          sleep 0.3
        end
      }
    end
  end
=begin
  Thread.new do
    while true
      sleep 10
      ActiveRecord::Base.connection_pool.with_connection{|con|
        Comment.find_each{ |comment|
          CommentScoreWorker.perform_async comment.id
          sleep 0.3
        }
      }
    end
  end
=end
  Thread.new do
    while true
      sleep 10
      #logger.info "Starting CollegeRecentPostNumberWorker cycle"
      ActiveRecord::Base.connection_pool.with_connection{|con|
        College.find_each{ |college|
          CollegeRecentPostNumberWorker.perform_async college.id
          sleep 0.3
        }
      }
    end
  end
end
