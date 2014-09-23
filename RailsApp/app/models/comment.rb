class Comment < ActiveRecord::Base


  belongs_to :post
  has_many :votes, as: :votable
  has_many :flags, as: :flaggable
  has_and_belongs_to_many :tags

  belongs_to :user, inverse_of: :comments

  validates :text, length: {minimum: 3, maximum: 140}
  
  after_initialize :init

  def init
    self.vote_delta ||= 0
  end

  after_create :make_vote, :make_tags, :increase_comment_count

  def make_vote
    self.votes.create({upvote: true})
  end

  def make_tags
    @words = text.split(/[\r\n\t ]+/)
    @words.each do |w|
      if w.length > 0 && w[0] == "#" then
        @text = w[1..-1]
        @existing = Tag.find_by casedText: @text
        if @existing.nil?
          @tag = tags.create({text: @text})
        elsif !tags.include? @existing
          tags << @existing
        end
      end
    end
  end

  def increase_comment_count
    if post
      post.comment_count += 1
      post.save
    end
  end

  after_destroy :decrease_comment_count

  def decrease_comment_count
    if post
      post.comment_count -= 1
      post.save
    end
  end

end
