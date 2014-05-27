require 'spec_helper'

describe "static_pages/show" do
  before(:each) do
    @static_page = assign(:static_page, stub_model(StaticPage))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
