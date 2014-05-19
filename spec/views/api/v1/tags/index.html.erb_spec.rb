require 'spec_helper'

describe "api/v1s/index" do
  before(:each) do
    assign(:api_v1_tags, [
      stub_model(Api::V1::Tag,
        :text => "Text",
        :post => nil
      ),
      stub_model(Api::V1::Tag,
        :text => "Text",
        :post => nil
      )
    ])
  end

  it "renders a list of api/v1s" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Text".to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
