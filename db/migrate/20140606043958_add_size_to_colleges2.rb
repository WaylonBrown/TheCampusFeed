class AddSizeToColleges2 < ActiveRecord::Migration
  def change
    add_column :colleges, :size, :integer
  end
end
