class CollegeRecentPostNumberWorker
  include Sidekiq::Worker

  def perform(college_id)
    college = College.find(college_id)
    college.recent_post_count = college.posts.where('created_at >= ?', Time.zone.now.beginning_of_day - 30.days).count
    college.save
  end
end
