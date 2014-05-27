require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Votes" do
  header "Content-Type", "application/json"

  before do
    @p = Post.create(:text => "Test post.", :id => 101);
    @p.votes.create(:upvote => true);
  end

  get "/api/v1/posts/101/votes/score" do
    example "Get the score of post ID 101" do
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
end
