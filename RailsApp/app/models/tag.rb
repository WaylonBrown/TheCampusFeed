class Tag < ActiveRecord::Base
  has_and_belongs_to_many :posts
  has_and_belongs_to_many :comments

  scope :top, ->(college, lim) {
    cid = {}
    if college
      cid["posts"] = {college_id: college.id}
    end

    select("tags.id, tags.text, count(posts.id) AS posts_count, count(comments.id) AS comments_count").
    joins(:posts).
    joins(:comments).
    where(cid).
    group("tags.id").
    order("posts_count DESC").
    limit(lim) }

  validates_presence_of :casedText
  validates_format_of :text, :with => /\A[^!\$%\^&+\.,#]*\z/, :on => :create

  before_validation :fix_casing

  def fix_casing
    self.casedText = self.text.clone
    self.text.downcase!
  end

end
