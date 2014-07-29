require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Votes" do
  header "Content-Type", "application/json"

  before do
    @p = Post.create(:text => "Test post.", :id => 101);
    @c = @p.comments.create(:text => "Test comment.", :id => 1);
    @p.votes.create(:upvote => true, :id => 69);
    @c.votes.create(:upvote => true);
  end

  get "/api/v1/posts/101/votes/score" do
    example "Get the score of post ID 101" do
      do_request
      status.should == 200
    end
  end

  get "/api/v1/posts/101/comments/1/votes/score" do
    example "Get the score of comment ID 1" do
      do_request
      status.should == 200
    end
  end

  post "/api/v1/posts/101/votes" do
    let(:raw_post) { params.to_json }

    parameter :upvote, "The new vote's upvote or downvote status.", :required => true

    example "Casting a vote on post ID 101" do
      do_request(
          :upvote => true,
      )
      status.should == 201
    end
  end

  post "/api/v1/posts/101/comments/1/votes" do
    let(:raw_post) { params.to_json }

    parameter :upvote, "The new vote's upvote or downvote status.", :required => true
    example "Casting a vote on comment ID 1" do
      do_request(
          :upvote => true,
      )
      status.should == 201
    end

  end

  delete "/api/v1/posts/101/comments/1/votes/69" do
    example "Removing vote id 69" do
      do_request
      status.should == 204
    end
  end
end
