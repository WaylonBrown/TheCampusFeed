class Post < ActiveRecord::Base

  has_many :comments
  has_many :votes, as: :votable
  has_many :flags, as: :flaggable
  has_and_belongs_to_many :tags
  belongs_to :college, inverse_of: :posts

  belongs_to :user, inverse_of: :posts


  validates :text, length: {minimum: 10, maximum: 140}

  after_initialize :init
  
  def init
    self.vote_delta ||= 0
    self.comment_count ||= 0
  end


  after_create :make_vote, :make_tags

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
end
