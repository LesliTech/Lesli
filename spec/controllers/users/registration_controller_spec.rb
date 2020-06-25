=begin

Lesli

Copyright (c) 2020, Lesli Technologies, S. A.

All the information provided by this website is protected by laws of Guatemala related 
to industrial property, intellectual property, copyright and relative international laws. 
Lesli Technologies, S. A. is the exclusive owner of all intellectual or industrial property
rights of the code, texts, trade mark, design, pictures and any other information.
Without the written permission of Lesli Technologies, S. A., any replication, modification,
transmission, publication is strictly forbidden.
For more information read the license file including with this software.

Lesli - Your Smart Business Assistant

Powered by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  <hello@lesli.tech>
@website  <https://lesli.tech>
@license  Propietary - all rights reserved.

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

=end

require 'rails_helper'
require 'spec_helper'

RSpec.configure do |config|
    config.include Devise::Test::ControllerHelpers, :type => :controller
end
=begin
RSpec.describe Users::RegistrationsController, type: :controller do

    before :each do
        request.env["devise.mapping"] = Devise.mappings[:user]
    end

    describe "POST:/users/registration" do

        user = {
            email: DateTime.now.strftime('%s').to_s+"@lesli.cloud",
            password: "lesli2020",
            password_confirmation: "lesli2020"
        }

        it "Register a new user" do
            post :create, params: {
                user: user
            }

            expect(response).to have_http_status(:success) 
            expect(response.content_type).to eq("application/json; charset=utf-8")
            expect(JSON.parse(response.body)["successful"]).to eql(true)
        end

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
=end
