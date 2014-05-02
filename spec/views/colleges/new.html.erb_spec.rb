require 'spec_helper'

describe "colleges/new" do
  before(:each) do
    assign(:college, stub_model(College,
      :name => "MyString",
      :state => "MyString",
      :lat => 1.5,
      :lon => 1.5
    ).as_new_record)
  end

  it "renders new college form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", colleges_path, "post" do
      assert_select "input#college_name[name=?]", "college[name]"
      assert_select "input#college_state[name=?]", "college[state]"
      assert_select "input#college_lat[name=?]", "college[lat]"
      assert_select "input#college_lon[name=?]", "college[lon]"
    end
  end
end
