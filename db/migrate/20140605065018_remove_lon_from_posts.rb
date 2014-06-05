class RemoveLonFromPosts < ActiveRecord::Migration
  def change
    remove_column :posts, :lon, :integer
  end
end
