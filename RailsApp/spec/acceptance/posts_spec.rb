require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Posts" do
  header "Content-Type", "application/json"

  before do
    Post.create(:text => "Test post.");
  end

  get "/api/v1/posts" do

    parameter :lat, "Your current latitude."
    parameter :lon, "Your current longitude."

    example "Listing posts" do
      do_request
      status.should == 200
    end
  end
  post "/api/v1/posts" do
    let(:raw_post) { params.to_json }

    parameter :post, "The new post.", :required => true

    example "Creating a post. This method scans the post text and discovers tags, creating post_tag relationships for each tag" do
      do_request(
        :text => "I yolo'd so hard I swagged myself #lol #swuggedmyself"
      )
      status.should == 201
    end
  end
end
