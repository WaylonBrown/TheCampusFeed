require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Versioner" do
  header "Content-Type", "application/json"

  before do
  end

  get "/api/v1/minAndroidVersion" do
    example "Android: get the minimum allowed application version" do
      do_request
      status.should == 200
    end
  end

  get "/api/v1/miniOSVersion" do
    example "iOS: get the minimum allowed application version" do
      do_request
      status.should == 200
    end
  end
end
