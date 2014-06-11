require 'spec_helper'

describe "Partials" do
  describe "GET /partials" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get partials_path
      response.status.should be(200)
    end
  end
end
