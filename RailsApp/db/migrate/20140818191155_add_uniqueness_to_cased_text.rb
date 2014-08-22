class AddUniquenessToCasedText < ActiveRecord::Migration
  def change
    add_index :tags, :casedText, :unique => true
  end
end
