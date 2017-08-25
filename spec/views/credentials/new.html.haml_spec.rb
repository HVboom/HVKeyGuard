require 'rails_helper'

RSpec.describe "credentials/new", type: :view do
  before(:each) do
    assign(:credential, Credential.new(
      :title => "MyString",
      :url => "MyString",
      :login => "MyString",
      :comment => "MyText",
      :token => "MyString",
      :secure => false
    ))
  end

  it "renders new credential form" do
    render

    assert_select "form[action=?][method=?]", credentials_path, "post" do

      assert_select "input[name=?]", "credential[title]"

      assert_select "input[name=?]", "credential[url]"

      assert_select "input[name=?]", "credential[login]"

      assert_select "textarea[name=?]", "credential[comment]"

      assert_select "input[name=?]", "credential[token]"

      assert_select "input[name=?]", "credential[secure]"
    end
  end
end
