require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Tags" do
  header "Content-Type", "application/json"

  before do
    @p = Post.create(:text => "Test post. #yolo #swag");
  end

  get "/api/v1/tags/trending" do
    #let(:raw_post) { params.to_json }

    #parameter :vote, "The new vote.", :required => true

    example "Get the currently trending tags" do
      do_request
      status.should == 200
    end

  end
end
