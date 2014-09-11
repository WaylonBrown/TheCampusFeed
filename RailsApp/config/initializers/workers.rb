require 'CommentScoreWorker'
require 'PostScoreWorker'

unless File.basename($0) == "rake"
  Thread.new do
    while true
      sleep 10
      Post.all.each{ |post|
        PostScoreWorker.perform_async post.id
        sleep 1
      }
    end
  end

  Thread.new do
    while true
      sleep 10
      Comment.all.each{ |comment|
        CommentScoreWorker.perform_async comment.id
        sleep 1
      }
    end
  end
end
