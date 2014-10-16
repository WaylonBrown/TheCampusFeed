class AddImageRefToPosts < ActiveRecord::Migration
  def change
    add_reference :posts, :image, index: true
  end
end
