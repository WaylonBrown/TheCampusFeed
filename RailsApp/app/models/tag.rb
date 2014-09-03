class Tag < ActiveRecord::Base
  has_and_belongs_to_many :posts
  has_and_belongs_to_many :comments

  scope :top, ->(college, lim) {
    cid = {}
    if college
      cid["posts"] = {college_id: college.id}
    end

    select("tags.id, tags.text, tags.casedText, count(posts.id) AS posts_count, count(comments.id) AS comments_count").
    includes(:posts, :comments).
    where(cid).#{id: 
    group("tags.text").
    having("count(posts.id) > 0").
    order("posts_count DESC").
    limit(lim).references(:comments) }

  validates_presence_of :casedText
  validates_format_of :text, :with => /\A[^!\$%\^&+\.,#]*\z/, :on => :create

  before_validation :fix_casing

  def fix_casing
    self.casedText = self.text.clone
    self.text.downcase!
  end

end
