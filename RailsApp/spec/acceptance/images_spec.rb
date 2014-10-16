require 'spec_helper'
require 'rspec_api_documentation/dsl'

resource "Images" do
  #header "Content-Type", "multipart/form-data"

  before do
  end

  post "/api/v1/images" do
=begin
    example "Upload an image to the CDN" do
      do_request(
        :image => {
          :upload => "BINARY_IMAGE_DATA"
        }
      )
      status.should == 200
    end
=end
  end

end
