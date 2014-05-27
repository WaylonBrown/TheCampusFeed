require 'spec_helper'

describe "static_pages/index" do
  before(:each) do
    assign(:static_pages, [
      stub_model(StaticPage),
      stub_model(StaticPage)
    ])
  end

  it "renders a list of static_pages" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
