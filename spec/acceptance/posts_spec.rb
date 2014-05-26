require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Posts" do
  header "Content-Type", "application/json"

  before do
    (1..7).each do |i|
      Post.create(:text => "its a #test post #{i}");
    end
  end

  get "/api/v1/posts" do

    parameter :lat, "Your current latitude."
    parameter :lon, "Your current longitude."

    example "Listing all posts" do
      do_request
      status.should == 200
    end

  end

  get '/api/v1/posts/byTag/test' do

    example 'Get posts by a tag:' do
      do_request
      status.should == 200
    end

    example 'Use pagination:' do
      do_request(
        :page => 2,
        :per_page => 3
      )
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

    example "Error when post is too short" do
      do_request(
        :text => "S"
      )
      status.should == 422
    end

    example "Error when post is too long" do
      do_request(
        :text => "test_test_test_test_test_test_test_test_test_test_test_test_test_test_test_test_test_test_test_test_test_test_test_test_"
      )
      status.should == 422
    end
  end
end
