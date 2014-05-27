require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Posts" do
  header "Content-Type", "application/json"


  before do
    @c = College.create(:name => "Swag University", :id => 2015)
    (1..2).each do |i|
      @c.posts.build(:text => "its a #test post #{i}");
    end
    @c.save
  end

  get "/api/v1/posts" do

    example "Listing all posts" do
      do_request
      status.should == 200
    end

  end

  get "/api/v1/colleges/2015/posts" do

    example "Listing all posts for college ID 2015" do
      do_request
      status.should == 200
    end

  end

  get '/api/v1/posts/byTag/test' do

    example 'Get posts by a tag' do
      do_request
      status.should == 200
    end

    example 'Use pagination' do
      do_request(
        :page => 2,
        :per_page => 3
      )
      status.should == 200
    end
  end

  post "/api/v1/colleges/2015/posts" do
    let(:raw_post) { params.to_json }

    parameter :post, "The new post.", :required => true

    example "Creating a post. Tags objects are created automatically." do
      do_request(
        :text => "This is a #comment #wtih #tag #testing #yo #yo #yo"
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
      o = [('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten
      longString = (0...150).map { o[rand(o.length)] }.join

      do_request(
        :text => longString 
      )
      status.should == 422
    end
  end
end
