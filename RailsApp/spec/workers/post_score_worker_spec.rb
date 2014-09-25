require 'spec_helper'
require 'sidekiq/testing'
Sidekiq::Testing.inline!

describe PostScoreWorker do

  # This should return the minimal set of attributes required to create a valid
  # User. As you add validations to User, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { { "token" => "MyString" } }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # UsersController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "Proper ordering" do
    it "ranks the most votes at the top" do
      post1 = Post.create!({text: "hello this is"})
      post2 = Post.create!({text: "helloi this is"})
      post3 = Post.create!({text: "hellot haisdfl"})

      (1..100).each {|i|
        post1.votes.create({upvote: true})
        post2.votes.create({upvote: Random.rand(10) < 8})
        post3.votes.create({upvote: Random.rand(10) < 3})
      }


      work = PostScoreWorker.perform_async(post1.id)
      work = PostScoreWorker.perform_async(post2.id)
      work = PostScoreWorker.perform_async(post3.id)

      expect(Post.find(post1.id).score).to be > Post.find(post2.id).score
      expect(Post.find(post2.id).score).to be > Post.find(post3.id).score
    end
  end



end
