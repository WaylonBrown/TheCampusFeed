class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :text
      t.integer :score
      t.float :lat
      t.float :lon

      t.timestamps
    end
  end
end
