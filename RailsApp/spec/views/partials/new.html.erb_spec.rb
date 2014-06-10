require 'spec_helper'

describe "partials/new" do
  before(:each) do
    assign(:partial, stub_model(Partial,
      :name => "MyString"
    ).as_new_record)
  end

  it "renders new partial form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", partials_path, "post" do
      assert_select "input#partial_name[name=?]", "partial[name]"
    end
  end
end
