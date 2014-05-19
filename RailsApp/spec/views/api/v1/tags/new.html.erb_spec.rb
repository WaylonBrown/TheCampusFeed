require 'spec_helper'

describe "api/v1s/new" do
  before(:each) do
    assign(:api_v1, stub_model(Api::V1::Tag,
      :text => "MyString",
      :post => nil
    ).as_new_record)
  end

  it "renders new api_v1 form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", api_v1_tags_path, "post" do
      assert_select "input#api_v1_text[name=?]", "api_v1[text]"
      assert_select "input#api_v1_post[name=?]", "api_v1[post]"
    end
  end
end
