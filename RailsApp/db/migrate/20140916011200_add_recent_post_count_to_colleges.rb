class AddRecentPostCountToColleges < ActiveRecord::Migration
  def change
    add_column :colleges, :recent_post_count, :integer
  end
end
