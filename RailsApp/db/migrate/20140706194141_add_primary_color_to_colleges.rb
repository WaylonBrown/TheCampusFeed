class AddPrimaryColorToColleges < ActiveRecord::Migration
  def change
    add_column :colleges, :primary_color, :string
  end
end
