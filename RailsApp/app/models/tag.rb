class Tag < ActiveRecord::Base
  has_and_belongs_to_many :posts
  scope :top25,
    select("tags.id, tags.text, count(posts.id) AS posts_count").
    joins(:posts).
    group("tags.id").
    order("posts_count DESC").
    limit(25)
end
