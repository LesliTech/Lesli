# =begin

# Copyright (c) 2020, all rights reserved.

# All the information provided by this platform is protected by international laws related  to 
# industrial property, intellectual property, copyright and relative international laws. 
# All intellectual or industrial property rights of the code, texts, trade mark, design, 
# pictures and any other information belongs to the owner of this platform.

# Without the written permission of the owner, any replication, modification,
# transmission, publication is strictly forbidden.

# For more information read the license file including with this software.

# // · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
# // · 

# =end

# include helpers, configuration & initializers for request tests
require "lesli_controller_helper"


RSpec.describe Users::SessionsController, type: :controller, :unless => defined?(DeutscheLeibrenten) do
    before :each do
        request.env["HTTP_ACCEPT"] = "application/json"
        request.env["devise.mapping"] = Devise.mappings[:user]

        # creates a new user for every test
        @password = "tardis2021$"
        @user = Account.first.users.create!({
            email: Faker::Internet.email,
            password: @password,
            password_confirmation: @password
        })
        user_roles = @user.user_roles.create({ role: Account.first.roles.find_by(name: "limited") })
        user_roles.roles.update(active: true)
        @user.confirm
    end

    it "login with valid credentials" do 

        post :create, params: {
            "user": {
                "email": @user.email,
                "password": @password
            }
        }

        expect_response_with_successful

    end


    it "try to login with not valid email" do 

        post :create, params: {
            "user": {
                "email": Faker::Internet.email,
                "password": @password
            }
        }

        expect_response_with_error
        expect(response_body["message"]).to eql(I18n.t("core.users/sessions.invalid_credentials"))

    end

    it "try to login with not valid password" do 

        post :create, params: {
            "user": {
                "email": @user.email,
                "password": Faker::Internet.password
            }
        }

        expect_response_with_error
        expect(response_body["message"]).to eql(I18n.t("core.users/sessions.invalid_credentials"))

    end

    it "try to login with valid credentials of unconfirmed user" do 

        user = Account.first.users.create!({
            email: Faker::Internet.email,
            password: @password,
            password_confirmation: @password
        })

        user.user_roles.create({ role: Account.first.roles.find_by(name: "limited") })

        post :create, params: {
            "user": {
                "email": user.email,
                "password": @password
            }
        }

        expect_response_with_error
        expect(response_body["message"]).to eql(I18n.t("devise.errors.custom.confirmation_required"))

    end

    it "try to login with not valid credentials of unconfirmed user" do 

        user = Account.first.users.create!({
            email: Faker::Internet.email,
            password: @password,
            password_confirmation: @password
        })

        user.user_roles.create({ role: Account.first.roles.find_by(name: "limited") })

        post :create, params: {
            "user": {
                "email": Faker::Internet.email,
                "password": Faker::Internet.password
            }
        }

        expect_response_with_error
        expect(response_body["message"]).to eql(I18n.t("core.users/sessions.invalid_credentials"))

    end

    it "Try to login with a user with no roles assigned" do 

        user = Account.first.users.create!({
            email: Faker::Internet.email,
            password: @password,
            password_confirmation: @password
        })

        user.confirm

        post :create, params: {
            "user": {
                "email": user.email,
                "password": @password
            }
        }

        expect_response_with_error
        expect(response_body["message"]).to eql(I18n.t("core.users/sessions.the_user_has_no_assigned_role"))

    end

    it "Try to login with a user with no active roles assigned" do 

        user = Account.first.users.create!({
            email: Faker::Internet.email,
            password: "tardis2021$",
            password_confirmation: "tardis2021$"
        })

        user_roles = user.user_roles.create({ role: Account.first.roles.find_by(name: "limited")})
        user_roles.roles.update(active: false)

        user.confirm

        post :create, params: {
            "user": {
                "email": user.email,
                "password": @password
            }
        }

        expect_response_with_error
        expect(response_body["message"]).to eql(I18n.t("deutscheleibrenten.users/sessions.role_access_denied"))

    end

end


RSpec.describe Users::SessionsController, type: :controller, :unless => defined?(DeutscheLeibrenten) do
    before :each do
        request.env["HTTP_ACCEPT"] = "application/json"
        request.env["devise.mapping"] = Devise.mappings[:user]

        # creates a new user for every test
        @account = Account.create!
        @account.onboarding!

        @password = Faker::Internet.password
        @user = @account.users.create!({
            email: Faker::Internet.email,
            password: @password,
            password_confirmation: @password
        })
        user_roles = @user.user_roles.create({ role: @account.roles.find_by(name: "owner") })
        user_roles.roles.update(active: true)
        @user.confirm

    end

    it "login using an owner role to an account in onboarding process" do

        post :create, params: {
            "user": {
                "email": @user.email,
                "password": @password
            }
        }

        expect_response_with_successful

        response_json = JSON.parse(response.body)
        expect(response_body["default_path"]).to eql("/onboarding")
    end
end

RSpec.describe Users::SessionsController, type: :controller, :unless => defined?(DeutscheLeibrenten) do
    before :each do
        request.env["HTTP_ACCEPT"] = "application/json"
        request.env["devise.mapping"] = Devise.mappings[:user]

        # creates a new user for every test
        @account = Account.create!
        @account.onboarding!

        @password = Faker::Internet.password
        @user = @account.users.create!({
            email: Faker::Internet.email,
            password: @password,
            password_confirmation: @password
        })
        user_roles = @user.user_roles.create({ role: @account.roles.find_by(name: "limited") })
        user_roles.roles.update(active: true)
        @user.confirm

    end

    it "login using a limited role to an account in onboarding process" do

        post :create, params: {
            "user": {
                "email": @user.email,
                "password": @password
            }
        }

        expect_response_with_successful

        response_json = JSON.parse(response.body)
        expect(response_body["default_path"]).not_to eql("/onboarding")
    end
end
