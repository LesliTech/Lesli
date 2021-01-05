=begin

Copyright (c) 2020, all rights reserved.

All the information provided by this platform is protected by international laws related  to 
industrial property, intellectual property, copyright and relative international laws. 
All intellectual or industrial property rights of the code, texts, trade mark, design, 
pictures and any other information belongs to the owner of this platform.

Without the written permission of the owner, any replication, modification,
transmission, publication is strictly forbidden.

For more information read the license file including with this software.

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

=end

require 'rails_helper'
require 'spec_helper'

RSpec.configure do |config|
    config.include Devise::Test::ControllerHelpers, :type => :controller
end

RSpec.describe Users::RegistrationsController, type: :controller do

    before :each do
        request.env["devise.mapping"] = Devise.mappings[:user]
    end

    describe "POST:/users/registration" do

        user = {
            email: DateTime.now.strftime('%s').to_s+"@lesli.cloud",
            password: "tardis2021$",
            password_confirmation: "tardis2021$"
        }

=begin
        it "Register a new user" do
            post :create, params: {
                user: user
            }

            expect(response).to have_http_status(:success) 
            expect(response.content_type).to eq("application/json; charset=utf-8")
            expect(JSON.parse(response.body)["successful"]).to eql(true)
        end
=end

=begin
        it "Register an existing user" do
            post :create, params: {
                user: user
            }
            expect(response).to have_http_status(:success) 
            expect(response.content_type).to eq("application/json; charset=utf-8")
            expect(JSON.parse(response.body)["successful"]).to eql(false)
            expect(JSON.parse(response.body)).to eql({
                "successful"=> false,
                "error"=>{
                    "details"=> [], 
                    "message"=> 'Email has already been taken'
                }
            })
        end
=end
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
                    "details"=> [], 
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
                    "details"=> [], 
                    "message"=> "Password can't be blank and Password confirmation doesn't match Password"
                }
            })
        end
        
    end

end

