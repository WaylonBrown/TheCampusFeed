require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Tags" do
  header "Content-Type", "application/json"

  before do
    @c = College.create(:id => 2015, :name => "Test College");

    @p = @c.posts.create(:text => "Test post. #yolo #swag");
    @p = @c.posts.create(:college_id => 2015, :text => "Another test post. #yolo #making #money #bitch.");

  end

  get "/api/v1/tags/trending" do
    #let(:raw_post) { params.to_json }

    #parameter :vote, "The new vote.", :required => true

    example "Get the currently trending tags" do
      do_request
      status.should == 200
    end

  end

  get "/api/v1/tags/trending?page=2&per_page=1" do

    example "Get page 2 of the currently trending tags" do
      do_request
      status.should == 200 && response_body.length.should > 0
    end

  end

  get "/api/v1/colleges/2015/tags/trending" do
    example "Get the currently trending tags for college ID 2015" do
      do_request
      status.should == 200
    end
  end

  get "/api/v1/colleges/2015/tags/trending?page=2&per_page=1" do
    example "Get the currently trending tags for college ID 2015" do
      do_request
      status.should == 200
    end
  end
end
