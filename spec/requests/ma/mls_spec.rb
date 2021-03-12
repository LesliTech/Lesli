=begin

Copyright (c) 2021, all rights reserved.
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


def user_configured_factory
    user = User.create(email: Faker::Internet.email, password:  "password")
    user.confirm
    user_roles = user.user_roles.create({ role: Account.first.roles.find_by(name: "limited") })
    user_roles.roles.update(active: true)
    user
end


describe Ma::MlsController, type: :request do
    describe 'GET #index' do
        context 'login request when user completes all the conditions to login' do
            describe 'login when token is Valid' do
                before(:all) do
                    user = user_configured_factory
                    token_auth_service = TokenAuthenticationService.new(user)
                    response = token_auth_service.create_token
                    get "/ma/mls.json", params: {
                            "token": response.payload[:token],
                            "user_id": user.id
                    }
                end

                it "is expected to log in" do
                    expect(JSON.parse(response.body)).to eql({
                                                                     "successful"=> true,
                                                                     "data" => nil
                                                             })
                end
                include_examples 'successful standard json response'
            end

            describe 'login error when user is wrong' do
                before(:all) do
                    user = user_configured_factory
                    token_auth_service = TokenAuthenticationService.new(user)
                    response = token_auth_service.create_token
                    get "/ma/mls.json", params: {
                            "token": response.payload[:token],
                            "user_id": "000000"
                    }
                end

                it "is expected not to log in" do
                    expect(JSON.parse(response.body)).to eql({"successful"=>false,"error"=>{"message"=>"invalid token","details"=>[]}})
                end
                include_examples 'error standard json response'
            end

            describe 'login error when token is wrong' do
                before(:all) do
                    user = user_configured_factory
                    get "/ma/mls.json", params: {
                            "token": 00000,
                            "user_id": user.id
                    }
                end

                it "is expected not to log in" do
                    expect(JSON.parse(response.body)).to eql({"successful"=>false,"error"=>{"message"=>"The token has already been used","details"=>[]}})
                end
                include_examples 'error standard json response'
            end

            describe 'login error when token that has already been used' do
                before(:all) do
                    user = user_configured_factory
                    token_auth_service = TokenAuthenticationService.new(user)
                    response = token_auth_service.create_token
                    get "/ma/mls.json", params: {
                            "token": response.payload[:token],
                            "user_id": user.id
                    }

                    get "/ma/mls.json", params: {
                            "token": response.payload[:token],
                            "user_id": user.id
                    }
                end

                it "is expected not to log in" do
                    expect(JSON.parse(response.body)).to eql({"successful"=>false,"error"=>{"message"=>"The token has already been used","details"=>[]}})
                end
                include_examples 'error standard json response'
            end

            describe 'login error when token is out of time' do
                before(:all) do
                    user = user_configured_factory
                    token_auth_service = TokenAuthenticationService.new(user)
                    response = token_auth_service.create_token

                    sleep 46
                    get "/ma/mls.json", params: {
                            "token": response.payload[:token],
                            "user_id": user.id
                    }
                end

                it "is expected not to log in" do
                    expect(JSON.parse(response.body)).to eql({"successful"=>false,"error"=>{"message"=>"The token has already been used","details"=>[]}})
                end
                include_examples 'error standard json response'
            end
        end


        context 'login request when invalid conditions for login' do
            describe 'login error when user is not active' do
                before(:all) do
                    user = User.create(email: Faker::Internet.email, password:  "password")
                    user_roles = user.user_roles.create({ role: Account.first.roles.find_by(name: "limited") })
                    user_roles.roles.update(active: true)
                    token_auth_service = TokenAuthenticationService.new(user)
                    response = token_auth_service.create_token
                    get "/ma/mls.json", params: {
                            "token": response.payload[:token],
                            "user_id": user.id
                    }
                end

                it "is expected to respond with an unconfirmed message" do
                    expect(JSON.parse(response.body)).to eql({
                                                                     "successful"=> false,
                                                                     "error"=> {
                                                                             "details"=> [],
                                                                             "message"=> I18n.t("devise.errors.custom.confirmation_required")
                                                                     }
                                                             })
                end
                include_examples 'error standard json response'
            end

            describe 'Sign in with a user without roles' do
                before(:all) do
                    user = User.create(email: Faker::Internet.email, password:  "password")
                    user.confirm

                    token_auth_service = TokenAuthenticationService.new(user)
                    response = token_auth_service.create_token
                    get "/ma/mls.json", params: {
                            "token": response.payload[:token],
                            "user_id": user.id
                    }
                end

                it "is expected to respond with a message of has not roles" do
                    expect(JSON.parse(response.body)).to eql({
                                                                     "successful"=> false,
                                                                     "error"=> {
                                                                             "details"=> [],
                                                                             "message"=> I18n.t("core.users/sessions.the_user_has_no_assigned_role")
                                                                     }
                                                             })
                end
                include_examples 'error standard json response'
            end

            describe 'Sign in with a user without active roles' do
                before(:all) do
                    user = User.create(email: Faker::Internet.email, password:  "password")
                    user.confirm
                    user_roles = user.user_roles.create({ role: Account.first.roles.find_by(name: "limited")})
                    user_roles.roles.update(active: false)

                    token_auth_service = TokenAuthenticationService.new(user)
                    response = token_auth_service.create_token
                    get "/ma/mls.json", params: {
                            "token": response.payload[:token],
                            "user_id": user.id
                    }
                end

                it "is expected to respond with an access denied message for inactive roles" do
                    expect(JSON.parse(response.body)).to eql({
                                                                     "successful"=> false,
                                                                     "error"=> {
                                                                             "details"=> [],
                                                                             "message"=> I18n.t("deutscheleibrenten.users/sessions.role_access_denied")
                                                                     }
                                                             })
                end
                include_examples 'error standard json response'
            end
        end
    end
end
