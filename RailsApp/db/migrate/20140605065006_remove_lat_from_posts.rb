class RemoveLatFromPosts < ActiveRecord::Migration
  def change
    remove_column :posts, :lat, :integer
  end
end
