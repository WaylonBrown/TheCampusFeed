require 'spec_helper'

describe "users/index" do
  before(:each) do
    assign(:users, [
      stub_model(User,
        :token => "Token",
        :secret => ""
      ),
      stub_model(User,
        :token => "Token",
        :secret => ""
      )
    ])
  end

  it "renders a list of users" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Token".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
  end
end
