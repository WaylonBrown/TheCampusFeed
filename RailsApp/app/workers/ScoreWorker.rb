class ScoreWorker 
  include Sidekiq::Worker

  def perform(name, count)
    p "hello"
  end
end
