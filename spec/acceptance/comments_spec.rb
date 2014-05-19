require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Comments" do
  header "Content-Type", "application/json"

  before do
    @p = Post.create(:text => "Test post.");
    @p.comments.create(:text => "Test comment.");
    @p.comments.create(:text => "Test comment number 2.");
  end
  get "/api/v1/comments" do

    parameter :postid, "The post id you are getting comments from.", :required => true

    example "Listing comments" do
      do_request(:postid => @p.id)
      status.should == 200
    end
  end
  post "/api/v1/comments" do
    let(:raw_post) { params.to_json }

    parameter :comment, "The new comment.", :required => true

    example "Creating a comment" do

      do_request(:post_id => @p.id, :text => "I lold so hard I shat myself.")
      status.should == 201
    end
  end
end
