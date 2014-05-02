module Api
  module V1
    class Comment < ActiveRecord::Base
      belongs_to :post
      has_many :votes, as: :votable
    end
  end
end
