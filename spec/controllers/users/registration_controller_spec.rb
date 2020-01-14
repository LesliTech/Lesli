require 'rails_helper'
require 'spec_helper'

RSpec.configure do |config|
    config.include Devise::Test::ControllerHelpers, :type => :controller
end

RSpec.describe Users::RegistrationsController, type: :controller do

    before :each do
        request.env["devise.mapping"] = Devise.mappings[:user]
    end

    describe "post:/users/registration" do

        it "Register a new user" do
            post :create, params: {
                user: {
                    email: "new_user@lesli.cloud",
                    password: "lesli2020",
                    password_confirmation: "lesli2020"
                }
            }
            expect(response).to have_http_status(:success) 
            expect(response.content_type).to eq("application/json; charset=utf-8")
            expect(JSON.parse(response.body)["successful"]).to eql(true)
            expect(JSON.parse(response.body)).to eql({ "successful"=> true })
        end

        it "Register an existing user" do
            post :create, params: {
                user: {
                    email: "admin@lesli.cloud",
                    password: "lesli2020",
                    password_confirmation: "lesli2020"
                }
            }
            expect(response).to have_http_status(:success) 
            expect(response.content_type).to eq("application/json; charset=utf-8")
            expect(JSON.parse(response.body)["successful"]).to eql(false)
            expect(JSON.parse(response.body)).to eql({
                "successful"=> false,
                "error"=>{
                    "details"=> nil, 
                    "message"=> "Email has already been taken"
                }
            })
        end

        it "Register with user and password in blank" do
            post :create, params: {
                user: {
                    email: "",
                    paswword: "",
                    password_confirmation: ""
                }
            }
            expect(response).to have_http_status(:success) 
            expect(response.content_type).to eq("application/json; charset=utf-8")
            expect(JSON.parse(response.body)["successful"]).to eql(false)
            expect(JSON.parse(response.body)).to eql({
                "successful"=> false,
                "error"=>{
                    "details"=> nil, 
                    "message"=> "Email can't be blank, Password can't be blank, and Password confirmation doesn't match Password"
                }
            })
        end

        it "Password doesn't match" do
            post :create, params: {
                user: {
                    email: "random@lesli.cloud",
                    paswword: "",
                    password_confirmation: ""
                }
            }
            expect(response).to have_http_status(:success) 
            expect(response.content_type).to eq("application/json; charset=utf-8")
            expect(JSON.parse(response.body)["successful"]).to eql(false)
            expect(JSON.parse(response.body)).to eql({
                "successful"=> false,
                "error"=> {
                    "details"=> nil, 
                    "message"=> "Password can't be blank and Password confirmation doesn't match Password"
                }
            })
        end

    end

end

