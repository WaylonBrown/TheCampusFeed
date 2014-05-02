module Api
  module V1
    class Vote < ActiveRecord::Base
      belongs_to :votable, polymorphic: true
    end
  end
end
