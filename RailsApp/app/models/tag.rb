class Tag < ActiveRecord::Base
  has_and_belongs_to_many :posts
  scope :top, ->(college, lim) {
    cid = {}
    if college
      cid["posts"] = {college_id: college.id}
    end
    select("tags.id, tags.text, count(posts.id) AS posts_count").
    joins(:posts).
    where(cid).
    group("tags.id").
    order("posts_count DESC").
    limit(lim) }

  validates_format_of :text, :with => /\A[^!\$%\^&+\.,]*\z/, :on => :create

end
