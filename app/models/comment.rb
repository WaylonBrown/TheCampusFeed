class Comment < ActiveRecord::Base
  belongs_to :post
  has_many :votes, as: :votable

  validates :text, length: {minimum: 3, maximum: 140}
end
