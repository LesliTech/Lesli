require 'rails_helper'

RSpec.describe Users::RegistrationsController, type: :controller do
    include Devise::Test::ControllerHelpers

    describe "GET #index" do
        it "responds successfylly with an HTTP 200 status code" do
            get :index
            expect(response).to be_redirect
            expect(response).to have_http_status(302)
        end

        it "test" do
            @request.env["devise.mapping"] = Devise.mappings[:user]
            role = FactoryBot.create(:role)
            sign_in FactoryBot.create(:user)
            expect(response).to have_http_status(200)
        end
    end
end
