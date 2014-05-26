class IndexTagsOnText < ActiveRecord::Migration
  def change
    add_index :tags, :text, unique: true
  end
end
