require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Comments" do
  header "Content-Type", "application/json"

  before do
    @p = Post.create(:text => "Test post.", :id => 1);
    @p.comments.create(:text => "Test comment.", :id => 1);
    @p.comments.create(:text => "Test comment number 2.", :id => 2);

    @p2 = Post.create(:text => "Test post number 2.", :id => 2);
    @p2.comments.create(:text => "Test comment number 3.");
    @p2.comments.create(:text => "Test comment number 4.");
    @p2.comments.create(:text => "another test", :id => 7, :hidden => true);
  end
  get "/api/v1/posts/1/comments" do

    #parameter :postid, "The post id you are getting comments from.", :required => true

    example "Listing comments for post ID 1" do
      do_request()
      status.should == 200
    end

  end
  get "/api/v1/posts/2/comments" do

    #parameter :postid, "The post id you are getting comments from.", :required => true

    example "Listing comments for post ID 2" do
      do_request()
      status.should == 200
    end

  end
  get '/api/v1/comments/many' do

    parameter :many_ids, "An array of comment IDs for which to get information. Hides hidden comments."
    example 'Get many comments from a list of comment IDs' do
      comment_ids = [1,2,7]
      do_request(
          :many_ids => comment_ids
      )
      status.should == 200
    end
  end

  post "/api/v1/posts/1/comments" do
    let(:raw_post) { params.to_json }

    parameter :text, "The new comment's text.", :required => true

    example "Creating a comment for a given post" do

      do_request(:text => "This is my comment on post id 1")
      status.should == 201
    end
  end
end
