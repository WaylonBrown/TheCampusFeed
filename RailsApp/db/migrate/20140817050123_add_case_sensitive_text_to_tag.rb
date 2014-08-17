class AddCaseSensitiveTextToTag < ActiveRecord::Migration
  def change
    add_column :tags, :casedText, :string
  end
end
