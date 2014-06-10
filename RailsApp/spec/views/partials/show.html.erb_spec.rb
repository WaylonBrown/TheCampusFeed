require 'spec_helper'

describe "partials/show" do
  before(:each) do
    @partial = assign(:partial, stub_model(Partial,
      :name => "Name"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
  end
end
