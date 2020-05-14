require 'rails_helper'

RSpec.describe "Settings", type: :request do
  include Devise::Test::IntegrationHelpers

  before(:all) do
      login_admin
  end

  def login_admin
      @user = User.find_by(email: "hello@lesli.cloud")
      sign_in @user
  end

  describe "GET /settings" do
    it "works! (now write some real specs)" do
      get settings_path
      expect(response).to have_http_status(200)
    end
  end
end
