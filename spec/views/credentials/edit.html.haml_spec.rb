require 'rails_helper'

RSpec.describe "credentials/edit", type: :view do
  before(:each) do
    @credential = assign(:credential, Credential.create!(
      :title => "MyString",
      :url => "MyString",
      :login => "MyString",
      :comment => "MyText",
      :token => "MyString",
      :secure => false
    ))
  end

  it "renders the edit credential form" do
    render

    assert_select "form[action=?][method=?]", credential_path(@credential), "post" do

      assert_select "input[name=?]", "credential[title]"

      assert_select "input[name=?]", "credential[url]"

      assert_select "input[name=?]", "credential[login]"

      assert_select "textarea[name=?]", "credential[comment]"

      assert_select "input[name=?]", "credential[token]"

      assert_select "input[name=?]", "credential[secure]"
    end
  end
end
