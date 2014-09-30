require 'CommentScoreWorker'
require 'PostScoreWorker'

unless File.basename($0) == "rake"
  Thread.new do
    while true
      sleep 10
      ActiveRecord::Base.connection_pool.with_connection{|con|
        Post.find_each{ |post|
          PostScoreWorker.perform_async post.id
          sleep 0.3
        }
      }
    end
  end

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

  Thread.new do
    while true
      sleep 10
      ActiveRecord::Base.connection_pool.with_connection{|con|
        College.find_each{ |college|
          CollegeRecentPostNumberWorker.perform_async college.id
          sleep 0.3
        }
      }
    end
  end
end
