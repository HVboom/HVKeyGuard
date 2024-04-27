require 'rails_helper'

RSpec.describe "credentials/index", type: :view do
  login_user

  before(:each) do
    assign(:credentials, Kaminari.paginate_array([
      Credential.create!(
        :title => "Title",
        :url => "Url",
        :login => "Login",
        :comment => "MyText",
        :token => "Token",
        :secured => false
      ),
      Credential.create!(
        :title => "Title2",
        :url => "Url2",
        :login => "Login2",
        :comment => "MyText2",
        :token => "Token2",
        :secured => false
      )
    ]).page(1).per(5))
  end

  it "renders a list of credentials" do
    render
    assert_select "tr>td", :text => /^Title/, :count => 2
    assert_select "tr>td", :text => /^Url/, :count => 2
    assert_select "tr>td", :text => /^Login/, :count => 2
    assert_select "tr>td", :text => /^MyText/, :count => 2
  end
end
