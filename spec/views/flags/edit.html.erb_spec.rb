require 'spec_helper'

describe "flags/edit" do
  before(:each) do
    @flag = assign(:flag, stub_model(Flag,
      :votable => nil
    ))
  end

  it "renders the edit flag form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", flag_path(@flag), "post" do
      assert_select "input#flag_votable[name=?]", "flag[votable]"
    end
  end
end
