require 'ScoreWorker'

Thread.new do
  while true
    ScoreWorker.perform_async
    sleep 10
  end
end
