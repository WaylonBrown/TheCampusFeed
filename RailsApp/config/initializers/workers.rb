require 'CommentScoreWorker'
require 'PostScoreWorker'

Thread.new do
  while true
    PostScoreWorker.perform_async
    sleep 30
  end
end

Thread.new do
  while true
    CommentScoreWorker.perform_async
    sleep 20
  end
end
