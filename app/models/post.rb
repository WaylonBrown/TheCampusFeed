class Post < ActiveRecord::Base
  has_many :comments
  has_many :votes, as: :votable
  has_and_belongs_to_many :tags
  belongs_to :college, inverse_of: :posts

  validates :text, length: {minimum: 10, maximum: 100}

  after_save :make_tags

  def make_tags
    @words = text.split(/[\r\n\t ]+/)
    @words.each do |w|
      if w.length > 0 && w[0] == "#" then
        @text = w[1..-1]
        @existing = Tag.find_by text: @text
        if @existing.nil?
          @tag = tags.build({text: @text})
          @tag.save
        elsif !tags.include? @existing
          tags << @existing
        end
      end
    end
  end
end
