class CreateCommentsTags < ActiveRecord::Migration
  def change
    create_table :comments_tags do |t|
      t.belongs_to :comment
      t.belongs_to :tag
    end
  end
end
