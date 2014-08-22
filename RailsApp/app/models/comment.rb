class Comment < ActiveRecord::Base
  include PgSearch
  pg_search_scope :search_by_text, :against => :text


  after_save :make_tags

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


  belongs_to :post
  has_many :votes, as: :votable
  has_many :flags, as: :flaggable
  has_and_belongs_to_many :tags

  belongs_to :user, inverse_of: :comments

  validates :text, length: {minimum: 3, maximum: 140}
end
