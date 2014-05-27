require 'spec_helper'

describe "users/edit" do
  before(:each) do
    @user = assign(:user, stub_model(User,
      :token => "MyString",
      :secret => ""
    ))
  end

  it "renders the edit user form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", user_path(@user), "post" do
      assert_select "input#user_token[name=?]", "user[token]"
      assert_select "input#user_secret[name=?]", "user[secret]"
    end
  end
end
