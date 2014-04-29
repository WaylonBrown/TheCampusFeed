require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Comments" do
  header "Content-Type", "application/json"

  before do
    @p = Post.create(:text => "Test post.");
    @p.comments.create(:text => "Test comment.");
    @p.comments.create(:text => "Test comment number 2.");
  end
  get "/comments" do

    parameter :postid, "The post id you are getting comments from.", :required => true

    example "Listing comments" do
      do_request(:format => "json", :postid => @p.id)
      status.should == 200
    end
  end
  post "/comments" do
    let(:raw_post) { params.to_json }

    parameter :comment, "The new comment.", :required => true

    example "Creating a comment" do
      do_request(
        :format => "json",
        :comment => {
          :post_id => @p.id,
          :text => "I find this highly offensive."
      })
      status.should == 201
    end
  end
end
