class AddLatLonToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :lat, :integer
    add_column :posts, :lon, :integer
  end
end
