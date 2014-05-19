require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Colleges" do

  header "Content-Type", "application/json"

  before do
    College.create(:name => "Texas A&M University", :lat => 30.614997, :lon => -96.342311);
    College.create(:name => "University of Texas", :lat => 30.284960, :lon => -97.734239);
  end

  get "/api/v1/colleges" do

    example "List all colleges" do
      do_request
      status.should == 200
    end

  end

  get "/api/v1/colleges/listNearby" do

    parameter :lat, "Your current latitude.", :required => true
    parameter :lon, "Your current longitude.", :required => true

    example "List nearby colleges" do
      do_request(
        lat: 10,
        lon: 10);
      status.should == 200
    end
  end

end
