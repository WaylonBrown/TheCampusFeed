class RemoveUniquenessOfTextIndex < ActiveRecord::Migration
  def change
    remove_index :tags, :text
    add_index :tags, :text
  end
end
