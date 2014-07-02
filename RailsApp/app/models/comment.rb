class Comment < ActiveRecord::Base
  include PgSearch
  pg_search_scope :search_by_text, :against => :text

  belongs_to :post
  has_many :votes, as: :votable
  has_many :flags, as: :flaggable

  belongs_to :user, inverse_of: :comments

  validates :text, length: {minimum: 3, maximum: 140}
end
