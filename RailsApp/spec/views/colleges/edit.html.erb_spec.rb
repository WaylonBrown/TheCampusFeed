require 'spec_helper'

describe "colleges/edit" do
  before(:each) do
    @college = assign(:college, stub_model(College,
      :name => "MyString",
      :state => "MyString",
      :lat => 1.5,
      :lon => 1.5
    ))
  end

  it "renders the edit college form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", college_path(@college), "post" do
      assert_select "input#college_name[name=?]", "college[name]"
      assert_select "input#college_state[name=?]", "college[state]"
      assert_select "input#college_lat[name=?]", "college[lat]"
      assert_select "input#college_lon[name=?]", "college[lon]"
    end
  end
end
