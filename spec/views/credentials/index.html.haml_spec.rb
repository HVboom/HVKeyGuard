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
        :url => "https://Url2",
        :login => "Login2",
        :token => "Token2",
        :secured => false
      )
    ]).page(1).per(5))
  end

  it "renders a list of credentials" do
    render
    assert_select "h5.card-title", :text => /^Title/, :count => 1
    assert_select "a.card-title", :href => /^http/, :count => 1
    assert_select "p.card-text", :text => /^Login/, :count => 2
    assert_select ".card-body > p", :text => /^MyText/, :count => 1
  end
end
