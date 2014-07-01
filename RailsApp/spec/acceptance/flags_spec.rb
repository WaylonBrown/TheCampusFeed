require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Flags" do
  header "Content-Type", "application/json"

  before do
    @p = Post.create(:text => "Test post.", :id => 101);
    #@p.comments.
  end

  post "/api/v1/posts/101/flags" do
    let(:raw_post) { params.to_json }

    example "Flagging post ID 101" do
      do_request(
        :votable_id => 101
      )
      status.should == 201
    end

  end
end
