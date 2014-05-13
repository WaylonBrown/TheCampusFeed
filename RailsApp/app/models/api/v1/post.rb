module Api
  module V1
    class Post < ActiveRecord::Base
      has_many :comments
      has_many :votes, as: :votable
      belongs_to :college, inverse_of: :posts
    end
  end
end
