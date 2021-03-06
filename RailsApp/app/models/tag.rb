class Tag < ActiveRecord::Base
  has_and_belongs_to_many :posts
  has_and_belongs_to_many :comments

  scope :top, ->(college, per, page) {
    @day_interval = 30

    @college_specifier = ""
    if college
      @college_specifier = "AND `posts`.`college_id` = #{college.id}"
    end

    @per_page = 25
    if per 
      @per_page = per
    end

    @actual_offset = 0
    if page
      if page < 1
        page = 1
      end
      @actual_offset = (page - 1) * @per_page
    end

    ActiveRecord::Base.connection.execute("SELECT casedText, MAX(posts_count + comments_count) FROM (
           SELECT tags.id, tags.text, tags.casedText, count(posts.id) AS posts_count, count(comments.id) AS comments_count 
           FROM `tags` 
           LEFT OUTER JOIN `posts_tags` ON `posts_tags`.`tag_id` = `tags`.`id` 
           LEFT OUTER JOIN `posts` ON `posts`.`id` = `posts_tags`.`post_id` AND `posts`.`created_at` > NOW() - INTERVAL #{@day_interval} DAY #{@college_specifier}
           LEFT OUTER JOIN `comments_tags` ON `comments_tags`.`tag_id` = `tags`.`id` 
           LEFT OUTER JOIN `comments` ON `comments`.`id` = `comments_tags`.`comment_id` AND  `comments`.`created_at` > NOW() - INTERVAL #{@day_interval} DAY GROUP BY `tags`.`casedText` 
           ) as T GROUP BY text HAVING sum(posts_count) > 0 ORDER BY posts_count DESC LIMIT #{@per_page} OFFSET #{@actual_offset}") }
=begin
    select("tags.id, tags.text, tags.casedText, count(posts.id) AS posts_count, count(comments.id) AS comments_count").
    includes(:posts, :comments).
    where(cid).#{id: 
    group("tags.text").
    having("count(posts.id) > 0").
    order("posts_count DESC").
    limit(lim).references(:comments) }
=end

  validates_presence_of :casedText
  validates_format_of :text, :with => /\A[A-Za-z0-9_]{3,139}\z/, :on => :create

  before_validation :fix_casing

  def fix_casing
    self.casedText = self.text.clone
    self.text.downcase!
  end

end
