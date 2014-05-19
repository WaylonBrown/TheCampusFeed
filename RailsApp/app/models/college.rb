class College < ActiveRecord::Base
  has_many :posts, inverse_of: :college
end
