class CreateColleges < ActiveRecord::Migration
  def change
    create_table :colleges do |t|
      t.string :name
      t.string :state
      t.float :lat
      t.float :lon

      t.timestamps
    end
  end
end
