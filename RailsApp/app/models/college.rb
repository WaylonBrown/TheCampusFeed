class College < ActiveRecord::Base
  include PgSearch
  pg_search_scope :search_by_text, :against => :name

  has_many :posts, inverse_of: :college
end