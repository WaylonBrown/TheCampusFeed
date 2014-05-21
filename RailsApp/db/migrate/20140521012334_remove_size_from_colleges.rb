class RemoveSizeFromColleges < ActiveRecord::Migration
  def change
    remove_column :colleges, :size, :integer
  end
end
