require 'spec_helper'

describe "flags/index" do
  before(:each) do
    assign(:flags, [
      stub_model(Flag,
        :votable => nil
      ),
      stub_model(Flag,
        :votable => nil
      )
    ])
  end

  it "renders a list of flags" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
