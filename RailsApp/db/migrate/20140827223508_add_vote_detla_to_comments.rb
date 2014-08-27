class AddVoteDetlaToComments < ActiveRecord::Migration
  def change
    add_column :comments, :vote_delta, :integer
  end
end
