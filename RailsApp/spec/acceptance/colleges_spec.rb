require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Colleges" do

  header "Content-Type", "application/json"

  before do
    College.create(:name => "Texas A&M University", :state => "TX", :lat => 30.614997, :lon => -96.342311);
    College.create(:name => "University of Texas", :state => "TX", :lat => 30.284960, :lon => -97.734239);
  end

  get "/colleges" do

    example "Listing colleges" do
      do_request(:format => "json")
      status.should == 200
    end

  end

end
