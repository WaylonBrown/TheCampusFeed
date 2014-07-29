require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Posts" do
  header "Content-Type", "application/json"

  before do
    @c = College.create(:name => "Swag University", :id => 2015)
    (1..3).each do |i|
      @c.posts.create(:text => "its a #test post #{i}", :id => i);
    end

    @c2 = College.create(:name => "Yolo University", :id => 2016)
    (4..6).each do |i|
      @c2.posts.create(:text => "its a #test post 2.0 #{i}", :id => i);
    end

      @c2.posts.create(:text => "its a #test post 2.0", :id => 7, :hidden => true);
    
  end

  get "/api/v1/posts" do

    example "Listing all posts" do
      do_request
      status.should == 200
    end

  end

  get "/api/v1/posts/recent" do

    example "Listing all recent posts" do
      do_request
      status.should == 200
    end

  end

  get "/api/v1/posts/trending" do

    example "Listing all trending posts" do
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

  get "/api/v1/colleges/2015/posts/recent" do

    example "Listing all recent posts for college ID 2015" do
      do_request
      status.should == 200
    end

  end

  get "/api/v1/colleges/2015/posts/trending" do

    example "Listing all trending posts for college ID 2015" do
      do_request
      status.should == 200
    end

  end

  get '/api/v1/posts/byTag/test' do

    example 'Get all posts using tag #test from all colleges' do
      do_request
      status.should == 200
    end

    example 'Get page 2 of all posts using tag #test from all colleges' do
      do_request(
        :page => 2,
        :per_page => 3
      )
      status.should == 200
    end
  end

  get '/api/v1/colleges/2015/posts/byTag/test' do
    example 'Get all posts using tag #test from college ID 2016' do
      do_request
      JSON.parse(response_body).length.should == 3
      status.should == 200
    end
  end

  get '/api/v1/posts/many' do
    let(:raw_post) { params.to_json }
    parameter :many_ids, "An array of post IDs for which to get information. Hides hidden posts"
    example 'Get many posts from a list of post IDs' do
      post_ids = [1,2,3,7]
      do_request(
          :many_ids => post_ids
      )
      status.should == 200
    end
  end

  post "/api/v1/colleges/2015/posts" do
    let(:raw_post) { params.to_json }

    parameter :text, "The new post's text.", :required => true
    parameter :user_token, "The user token.", :required => true

    example "Creating a post (tags objects are created automatically)" do
      do_request(
        :text => "This is a #post #wtih #tag #testing #yo #yo #yo",
        :user_token => "18006969696"
      )
      status.should == 201
    end


    
    example "Creating a post with an invalid hashtag" do

      do_request(
        :text => "This is a ##@$@#%",
        :user_token => "18006969696"
      )
      status.should == 201
    end

    example "Error when post is too short" do
      do_request(
        :text => "S",
        :user_token => "18006969696"
      )
      status.should == 422
    end

    example "Error when post is too long" do
      o = [('a'..'z'), ('A'..'Z')].map { |i| i.to_a }.flatten
      longString = (0...150).map { o[rand(o.length)] }.join

      do_request(
        :text => longString,
        :user_token => "18006969696"
      )
      status.should == 422
    end
  end
  get "/api/v1/posts/hidden" do
    example "Listing all hidden posts" do
      do_request()
      status.should == 200
    end
  end
end
