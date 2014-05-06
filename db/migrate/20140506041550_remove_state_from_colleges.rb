class RemoveStateFromColleges < ActiveRecord::Migration
  def change
    remove_column :colleges, :state, :string
  end
end
