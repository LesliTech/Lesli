
require 'rails_helper'
require 'spec_helper'

RSpec.configure do |config|
    config.include Devise::Test::ControllerHelpers, :type => :controller
end

RSpec.describe Users::RegistrationsController, type: :controller do

    before :each do
        request.env["devise.mapping"] = Devise.mappings[:user]
    end

    describe "Devise user registration (sign_up)" do
        it "Register a new user" do
            post :create, params: {
                sign_up: {
                    email: "mail@gmail.com",
                    password: "abcd1234",
                    password_confirmation: "abcd12340"
                }
            }
            expect(response).to have_http_status(:redirect)
            expect(response.status).to eq(302)
            expect(response).to redirect_to(root_path)
            expect(flash[:success]).to be_present
            expect(flash[:success]).to match(/Check your email to confirm your account/)
        end
    end
end
