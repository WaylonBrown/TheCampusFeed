require 'spec_helper'

describe "partials/edit" do
  before(:each) do
    @partial = assign(:partial, stub_model(Partial,
      :name => "MyString"
    ))
  end

  it "renders the edit partial form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", partial_path(@partial), "post" do
      assert_select "input#partial_name[name=?]", "partial[name]"
    end
  end
end
