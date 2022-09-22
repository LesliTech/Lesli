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
                password: "Tardis2021$",
                password_confirmation: "Tardis2021$"
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


    it "Try to create an already existing user" do

        user = FactoryBot.create(:user)

        post :create, params: {
            user: {
                email: user.email, # this is registered already
                password: "Tardis2021$",
                password_confirmation: "Tardis2021$"
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

    it "Try to create a user with empty email and password" do

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

    it "Try to create an user with mismatch password" do

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

    it "Try to create an user with first name, last name and telephone" do

        post :create, params: {
            user: {
                email: Faker::Internet.email,
                password: "Tardis2022$",
                password_confirmation: "Tardis2022$",
                detail_attributes: {
                    first_name: Faker::Name.first_name,
                    last_name: Faker::Name.last_name,
                    telephone: Faker::PhoneNumber.phone_number,
                }
            }
        }

        unless @allow_registration
            expect_response_with_error
            expect(response_body["message"]).to eql(I18n.t("core.users/registrations.messages_error_registration_not_allowed"))
        else
            expect_response_with_successful
        end
    end
end
