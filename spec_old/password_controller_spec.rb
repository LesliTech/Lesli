require 'rails_helper'
require 'spec_helper'

RSpec.configure do |config|
    config.include Devise::Test::ControllerHelpers, :type => :controller
end

RSpec.describe Users::PasswordsController, type: :controller do

    before :each do
        request.env["devise.mapping"] = Devise.mappings[:user]
    end

    describe "POST:/users/password" do

        it "Not valid email" do
            post :create, params: {
                user: {
                    email: "random@lesli.cloud"
                }
            }
            expect(response).to have_http_status(:success) 
            expect(response.content_type).to eq("application/json; charset=utf-8")
            expect(JSON.parse(response.body)["successful"]).to eql(false)
            expect(JSON.parse(response.body)).to eql({
                "successful"=> false,
                "error"=> {
                    "details"=> [], 
                    "message"=> I18n.t('core.users/passwords.error_invalid_email')
                }
            })
        end

    end
end
