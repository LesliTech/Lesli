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

# include helpers, configuration & initializers for request tests
require 'lesli_controller_helper'


RSpec.describe Users::RegistrationsController, type: :controller, :unless => defined?(DeutscheLeibrenten) do

    before :each do
        request.env["devise.mapping"] = Devise.mappings[:user]
        @allow_registration =  Rails.application.config.lesli[:security][:allow_registration]
        @password = Faker::Internet.password(min_length: 8, max_length: 10, mix_case: true) + "1$"
    end

    it "Create a new standard user" do

        Account.first.settings.where(:name => "password_digit_count").update(:value => 1)
        Account.first.settings.where(:name => "password_minimum_length").update(:value => 6)
        Account.first.settings.where(:name => "password_lowercase_count").update(:value => 1)
        Account.first.settings.where(:name => "password_uppercase_count").update(:value => 1)
        Account.first.settings.where(:name => "password_special_char_count").update(:value => 1)

        post(:create, params: {
            user: {
                email: Faker::Internet.email,
                password: @password,
                password_confirmation: @password
            }
        })

        pp(response.body)

        unless @allow_registration
            expect_response_with_error
            expect(response_body["message"]).to eql(I18n.t("core.users/registrations.messages_error_registration_not_allowed"))
        else
            expect_response_with_successful
        end
    end

    it "Tries to create an already existing user" do

        user = FactoryBot.create(:user)

        post :create, params: {
            user: {
                email: user.email, # this is registered already
                password: @password,
                password_confirmation: @password
            }
        }

        unless @allow_registration
            expect_response_with_error
            expect(response_body["message"]).to eql(I18n.t("core.users/registrations.messages_error_registration_not_allowed"))
        else
            expect_response_with_error
            expect(response_body["message"]).to eql(I18n.t('core.users/registrations.messages_info_user_already_exists'))
        end
    end

    it "Tries to create an user with empty email and password" do

        post :create, params: {
            user: {
                email: "",
                paswword: "",
                password_confirmation: ""
            }
        }

        unless @allow_registration
            expect_response_with_error
            expect(response_body["message"]).to eql(I18n.t("core.users/registrations.messages_error_registration_not_allowed"))
        else
            expect_response_with_error
            expect(response_body["message"]).to eql("password_complexity_error")
        end
    end

    it "Tries to create an user with mismatch password" do

        post :create, params: {
            user: {
                email: Faker::Internet.email,
                paswword: "123",
                password_confirmation: "abc"
            }
        }

        unless @allow_registration
            expect_response_with_error
            expect(response_body["message"]).to eql(I18n.t("core.users/registrations.messages_error_registration_not_allowed"))
        else
            expect_response_with_error
            expect(response_body["message"]).to eql("password_complexity_error")
        end
    end

    it "Tries to create an user with first name, last name and telephone" do

        user = {
            email: Faker::Internet.email,
            password: @password,
            password_confirmation: @password,
            detail_attributes: {
                first_name: Faker::Name.first_name,
                last_name: Faker::Name.last_name,
                telephone: Faker::PhoneNumber.phone_number
            }
        }
        
        post :create, params: {
            user: user
        }

        unless @allow_registration
            expect_response_with_error
            expect(response_body["message"]).to eql(I18n.t("core.users/registrations.messages_error_registration_not_allowed"))
        else
            expect_response_with_successful

            registered_user = User.find_by_email(user[:email])

            expect(registered_user.detail.first_name).to be_a(String)
            expect(registered_user.detail.last_name).to  be_a(String)
            expect(registered_user.detail.telephone).to  be_a(String)
        end
    end


    it "Tries to create an user with empty first name, last name and telephone" do

        user = {
            email: Faker::Internet.email,
            password: @password,
            password_confirmation: @password,
            detail_attributes: {
                first_name: "",
                last_name: "",
                telephone: "",
            }
        }

        post :create, params: {
            user: user
        }

        unless @allow_registration
            expect_response_with_error
            expect(response_body["message"]).to eql(I18n.t("core.users/registrations.messages_error_registration_not_allowed"))
        else
            expect_response_with_successful

            registered_user = User.find_by_email(user[:email])

            expect(registered_user.detail.first_name).to be_blank
            expect(registered_user.detail.last_name).to  be_blank
            expect(registered_user.detail.telephone).to  be_blank
        end
    end


    it "Tries to create an user without telephone in detail_attributes" do

        user = {
            email: Faker::Internet.email,
            password: @password,
            password_confirmation: @password,
            detail_attributes: {
                first_name: Faker::Name.first_name,
                last_name: Faker::Name.last_name
            }
        }

        post :create, params: {
            user: user
        }

        unless @allow_registration
            expect_response_with_error
            expect(response_body["message"]).to eql(I18n.t("core.users/registrations.messages_error_registration_not_allowed"))
        else
            expect_response_with_successful

            registered_user = User.find_by_email(user[:email])

            expect(registered_user.detail.first_name).to be_a(String)
            expect(registered_user.detail.last_name).to be_a(String)
            expect(registered_user.detail.telephone).to be_blank
            
        end
    end

    it "Tries to create an user without first_name in detail_attributes" do

        user = {
            email: Faker::Internet.email,
            password: @password,
            password_confirmation: @password,
            detail_attributes: {
                last_name: Faker::Name.last_name,
                telephone: Faker::PhoneNumber.phone_number
            }
        }

        post :create, params: {
            user: user
        }

        unless @allow_registration
            expect_response_with_error
            expect(response_body["message"]).to eql(I18n.t("core.users/registrations.messages_error_registration_not_allowed"))
        else
            expect_response_with_successful

            registered_user = User.find_by_email(user[:email])

            expect(registered_user.detail.first_name).to be_blank
            expect(registered_user.detail.last_name).to be_a(String)
            expect(registered_user.detail.telephone).to be_a(String)
        end
    end

    it "Tries to create an user without last_name in detail_attributes" do

        user = {
            email: Faker::Internet.email,
            password: @password,
            password_confirmation: @password,
            detail_attributes: {
                first_name: Faker::Name.first_name,
                telephone: Faker::PhoneNumber.phone_number
            }
        }

        post :create, params: {
            user: user
        }

        unless @allow_registration
            expect_response_with_error
            expect(response_body["message"]).to eql(I18n.t("core.users/registrations.messages_error_registration_not_allowed"))
        else
            expect_response_with_successful

            registered_user = User.find_by_email(user[:email])

            expect(registered_user.detail.first_name).to be_a(String)
            expect(registered_user.detail.last_name).to be_blank
            expect(registered_user.detail.telephone).to be_a(String)
        end
    end


    it "Tries to create an user with empty detail_attributes" do

        user = {
            email: Faker::Internet.email,
            password: @password,
            password_confirmation: @password,
            detail_attributes: {}
        }

        post :create, params: {
            user: user
        }

        unless @allow_registration
            expect_response_with_error
            expect(response_body["message"]).to eql(I18n.t("core.users/registrations.messages_error_registration_not_allowed"))
        else
            expect_response_with_successful

            registered_user = User.find_by_email(user[:email])

            #verify that the user is created without detail attributes
            expect(registered_user.detail.first_name).to be_blank
            expect(registered_user.detail.last_name).to be_blank
            expect(registered_user.detail.telephone).to be_blank
            
        end
    end


    it "Tries to create an user with incorrect detail_attributes" do

        user = {
            email: Faker::Internet.email,
            password: @password,
            password_confirmation: @password,
            detail_attributes: {
                FIRST_NAME: Faker::Name.first_name,
                LAST_NAME: Faker::Name.last_name,
                TELEPHONE: Faker::PhoneNumber.phone_number
            }
        }

        post :create, params: {
            user: user
        }

        unless @allow_registration
            expect_response_with_error
            expect(response_body["message"]).to eql(I18n.t("core.users/registrations.messages_error_registration_not_allowed"))
        else
            expect_response_with_successful

            registered_user = User.find_by_email(user[:email])

            #verify that the user is created without detail attributes
            expect(registered_user.detail.first_name).to be_blank
            expect(registered_user.detail.last_name).to be_blank
            expect(registered_user.detail.telephone).to be_blank
            
        end
    end
end
