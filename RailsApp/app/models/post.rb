class Post < ActiveRecord::Base
  has_many :comments
  has_many :votes, as: :votable
  has_and_belongs_to_many :tags
  belongs_to :college, inverse_of: :posts
end
