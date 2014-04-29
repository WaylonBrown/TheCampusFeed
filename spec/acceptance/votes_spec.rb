require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Votes" do
  header "Content-Type", "application/json"

  before do
    @p = Post.create(:text => "Test post.");
    @p.votes.create(:upvote => true);
  end

  post "/votes" do
    let(:raw_post) { params.to_json }

    parameter :vote, "The new vote.", :required => true

    example "Casting a vote on an item" do
      do_request(
        :format => "json",
        :vote => {
        :upvote => true,
        :votable_id => @p.id
      })
      status.should == 201
    end

  end
end
