require 'rails_helper'

RSpec.describe "credentials/index", type: :view do
  before(:each) do
    assign(:credentials, [
      Credential.create!(
        :title => "Title",
        :url => "Url",
        :login => "Login",
        :comment => "MyText",
        :token => "Token",
        :secure => false
      ),
      Credential.create!(
        :title => "Title",
        :url => "Url",
        :login => "Login",
        :comment => "MyText",
        :token => "Token",
        :secure => false
      )
    ])
  end

  it "renders a list of credentials" do
    render
    assert_select "tr>td", :text => "Title".to_s, :count => 2
    assert_select "tr>td", :text => "Url".to_s, :count => 2
    assert_select "tr>td", :text => "Login".to_s, :count => 2
    assert_select "tr>td", :text => "MyText".to_s, :count => 2
    assert_select "tr>td", :text => "Token".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
