require 'spec_helper'

describe "votes/edit" do
  before(:each) do
    @vote = assign(:vote, stub_model(Vote,
      :upvote => false,
      :votable_id => 1,
      :votable_type => "MyString"
    ))
  end

  it "renders the edit vote form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", vote_path(@vote), "post" do
      assert_select "input#vote_upvote[name=?]", "vote[upvote]"
      assert_select "input#vote_votable_id[name=?]", "vote[votable_id]"
      assert_select "input#vote_votable_type[name=?]", "vote[votable_type]"
    end
  end
end
