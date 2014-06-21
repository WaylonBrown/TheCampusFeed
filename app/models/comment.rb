class Comment < ActiveRecord::Base
  belongs_to :post
  has_many :votes, as: :votable
  has_many :flags, as: :votable

  belongs_to :user, inverse_of: :comments

  validates :text, length: {minimum: 3, maximum: 140}
end
