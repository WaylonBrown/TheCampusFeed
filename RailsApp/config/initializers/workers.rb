require 'ScoreWorker'

Thread.new do
  while true

    p "going to add"
    ScoreWorker.perform_async("example", 3)
    p "added to redis"

    sleep 1
  end
end
