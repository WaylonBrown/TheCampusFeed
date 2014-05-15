class AddCollegeRefToPosts < ActiveRecord::Migration
  def change
    add_reference :posts, :college, index: true
  end
end
