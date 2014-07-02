class Post < ActiveRecord::Base
  include PgSearch
  pg_search_scope :search_by_text, :against => :text

  has_many :comments
  has_many :votes, as: :votable
  has_many :flags, as: :flaggable
  has_and_belongs_to_many :tags
  belongs_to :college, inverse_of: :posts

  belongs_to :user, inverse_of: :posts


  validates :text, length: {minimum: 10, maximum: 140}

  after_save :make_tags

  def comment_count
    comments.count
  end

  def as_json(options = { })
    h = super(options)
    h[:comment_count] = comment_count
    h
  end

  def make_tags
    @words = text.split(/[\r\n\t ]+/)
    @words.each do |w|
      if w.length > 0 && w[0] == "#" then
        @text = w[1..-1]
        @existing = Tag.find_by text: @text
        if @existing.nil?
          @tag = tags.create({text: @text})
        elsif !tags.include? @existing
          tags << @existing
        end
      end
    end
  end

end
