require 'CommentScoreWorker'
require 'PostScoreWorker'

unless File.basename($0) == "rake"
  Thread.new do
    while true
      sleep 10
      @posts = []
      ActiveRecord::with_connection{|con|
        @posts = Post.all
      }
      @posts.each{ |post|
        PostScoreWorker.perform_async post.id
        sleep 0.3
      }
    end
  end

  Thread.new do
    while true
      sleep 10
      @comments = []
      ActiveRecord::with_connection{|con|
        @comments = Comment.all
      }
      @comments.each{ |comment|
        CommentScoreWorker.perform_async comment.id
        sleep 0.3
      }
    end
  end

  Thread.new do
    while true
      sleep 10
      @colleges = []
      ActiveRecord::with_connection{|con|
        @colleges = College.all
      }
      @colleges.each{ |college|
        CollegeRecentPostNumberWorker.perform_async college.id
        sleep 0.3
      }
    end
  end
end
