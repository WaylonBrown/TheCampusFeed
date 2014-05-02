require 'spec_helper'

describe "colleges/index" do
  before(:each) do
    assign(:colleges, [
      stub_model(College,
        :name => "Name",
        :state => "State",
        :lat => 1.5,
        :lon => 1.5
      ),
      stub_model(College,
        :name => "Name",
        :state => "State",
        :lat => 1.5,
        :lon => 1.5
      )
    ])
  end

  it "renders a list of colleges" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "State".to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
  end
end
