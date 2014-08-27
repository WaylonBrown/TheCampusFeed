class AddVoteDeltaToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :vote_delta, :integer
  end
end
