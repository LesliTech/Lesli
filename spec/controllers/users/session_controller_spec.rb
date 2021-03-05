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
require 'faker'


RSpec.configure do |config|
    config.include Devise::Test::ControllerHelpers, :type => :controller
end


RSpec.describe Users::SessionsController, type: :request do
    describe 'Sign in with valid credentials' do
        before(:all) do
            user = Account.first.users.create!({
                                                       email: Faker::Internet.email,
                                                       password: "tardis2021$",
                                                       password_confirmation: "tardis2021$"
                                               })
            user_roles = user.user_roles.create({ role: Account.first.roles.find_by(name: "limited") })
            user_roles.roles.update(active: true)
            user.confirm
            post "/login", params: {
                    "user": {
                            "email": user.email,
                            "password": "tardis2021$"
                    }
            }
        end
        it "is expected to respond with successful" do
            expect(JSON.parse(response.body)).to eql({
                                                             "successful"=> true,
                                                             "data" => nil
                                                     })
        end
        include_examples 'successful standard json response'
    end

    describe 'Sign in with wrong username' do
        before(:all) do
            post :"/login", params: {
                    user: {
                            user: "wrong@user.email",
                            password: "lesli2020"
                    }
            }
        end
        it "is expected to respond with successful" do
            expect(JSON.parse(response.body)).to eql({
                                                             "successful"=> false,
                                                             "error"=> {
                                                                     "details"=> [],
                                                                     "message"=> I18n.t("core.users/sessions.invalid_credentials")
                                                             }
                                                     })
        end
        include_examples 'error standard json response'
    end

    describe 'Sign in with an unconfirmed user' do
        before(:all) do
            user = Account.first.users.create!({
                                                       email: Faker::Internet.email,
                                                       password: "tardis2021$",
                                                       password_confirmation: "tardis2021$"
                                               })
            user.user_roles.create({ role: Account.first.roles.find_by(name: "limited") })
            post "/login", params: {
                    "user": {
                            "email": user.email,
                            "password": "tardis2021$"
                    }
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
            user = Account.first.users.create!({
                                                       email: Faker::Internet.email,
                                                       password: "tardis2021$",
                                                       password_confirmation: "tardis2021$"
                                               })
            user.confirm
            post "/login", params: {
                    "user": {
                            "email": user.email,
                            "password": "tardis2021$"
                    }
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
            user = Account.first.users.create!({
                                                       email: Faker::Internet.email,
                                                       password: "tardis2021$",
                                                       password_confirmation: "tardis2021$"
                                               })
            user_roles = user.user_roles.create({ role: Account.first.roles.find_by(name: "limited")})
            user_roles.roles.update(active: false)

            user.confirm
            post "/login", params: {
                    "user": {
                            "email": user.email,
                            "password": "tardis2021$"
                    }
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