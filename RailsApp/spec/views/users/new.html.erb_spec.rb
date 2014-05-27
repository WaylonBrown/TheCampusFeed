require 'spec_helper'

describe "users/new" do
  before(:each) do
    assign(:user, stub_model(User,
      :token => "MyString",
      :secret => ""
    ).as_new_record)
  end

  it "renders new user form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", users_path, "post" do
      assert_select "input#user_token[name=?]", "user[token]"
      assert_select "input#user_secret[name=?]", "user[secret]"
    end
  end
end
