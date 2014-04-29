require 'spec_helper'

describe "votes/new" do
  before(:each) do
    assign(:vote, stub_model(Vote,
      :upvote => false,
      :votable_id => 1,
      :votable_type => "MyString"
    ).as_new_record)
  end

  it "renders new vote form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", votes_path, "post" do
      assert_select "input#vote_upvote[name=?]", "vote[upvote]"
      assert_select "input#vote_votable_id[name=?]", "vote[votable_id]"
      assert_select "input#vote_votable_type[name=?]", "vote[votable_type]"
    end
  end
end
