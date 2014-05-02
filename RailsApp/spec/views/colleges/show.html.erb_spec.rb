require 'spec_helper'

describe "colleges/show" do
  before(:each) do
    @college = assign(:college, stub_model(College,
      :name => "Name",
      :state => "State",
      :lat => 1.5,
      :lon => 1.5
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/State/)
    rendered.should match(/1.5/)
    rendered.should match(/1.5/)
  end
end
