module Api
  module V1
    class College < ActiveRecord::Base
      has_many :posts, inverse_of: :college
    end
  end
end
