require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Posts" do
  header "Content-Type", "application/json"

  before do
    Post.create(:text => "Test post.");
  end

  get "/posts" do

    parameter :lat, "Your current latitude."
    parameter :lon, "Your current longitude."

    example "Listing posts" do
      do_request(:format => "json")

      status.should == 200
    end
  end
  post "/posts" do
    let(:raw_post) { params.to_json }

    parameter :post, "The new post.", :required => true

    example "Creating a post" do
      do_request(
        :format => "json",
        :post => {
        :text => "#YOLO SWAG!"
      })
      status.should == 201
    end
  end
end
