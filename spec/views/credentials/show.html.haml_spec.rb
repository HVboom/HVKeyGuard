require 'rails_helper'

RSpec.describe "credentials/show", type: :view do
  before(:each) do
    @credential = assign(:credential, Credential.create!(
      :title => "Title",
      :url => "Url",
      :login => "Login",
      :comment => "MyText",
      :token => "Token",
      :secure => false
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Title/)
    expect(rendered).to match(/Url/)
    expect(rendered).to match(/Login/)
    expect(rendered).to match(/MyText/)
    expect(rendered).to match(/Token/)
    expect(rendered).to match(/false/)
  end
end
