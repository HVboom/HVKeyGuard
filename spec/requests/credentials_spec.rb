require 'rails_helper'

RSpec.describe "Credentials", type: :request do
  let(:user) { FactoryBot.create(:user) }

  describe "GET /credentials" do
    it "works! (now write some real specs)" do
      sign_in user
      get credentials_path
      expect(response).to render_template(:index)
      expect(response).to have_http_status(200)
    end
  end
end
