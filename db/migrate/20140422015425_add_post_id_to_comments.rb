class AddPostIdToComments < ActiveRecord::Migration
  def change
    add_column :comments, :post_id, :string
    add_index :comments, :post_id
  end
end
