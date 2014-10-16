require 'spec_helper'

describe "images/edit" do
  before(:each) do
    @image = assign(:image, stub_model(Image,
      :uri => "MyString"
    ))
  end

  it "renders the edit image form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", image_path(@image), "post" do
      assert_select "input#image_uri[name=?]", "image[uri]"
    end
  end
end
