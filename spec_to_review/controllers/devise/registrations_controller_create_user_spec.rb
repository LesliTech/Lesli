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

RSpec.describe Users::RegistrationsController, type: :controller do

    before :each do
        @allow_registration =  Rails.application.config.lesli_settings["security"]["allow_registration"]
        request.env["devise.mapping"] = Devise.mappings[:user]
    end

    it "Create a new standard user" do

        post :create, params: {
            user: {
                email: (User.last.id + 1).to_s+"@lesli.cloud",
                password: "tardis2021$",
                password_confirmation: "tardis2021$"
            }
        }

        unless @allow_registration
            expect_json_response_error
            expect(response_error["message"]).to eql(I18n.t("core.users/registrations.messages_error_registration_not_allowed"))
        else
            expect_json_response_successful
        end
    end


    it "Try to create an already existing user" do

        user = FactoryBot.create(:user)

        post :create, params: {
            user: {
                email: user.email, # this is registered already
                password: "tardis2021$",
                password_confirmation: "tardis2021$"
            }
        }

        unless @allow_registration
            expect_json_response_error
            expect(response_error["message"]).to eql(I18n.t("core.users/registrations.messages_error_registration_not_allowed"))
        else
            expect_json_response_error
            expect(response_error["message"]).to eql(I18n.t('core.users/registrations.messages_info_user_already_exists'))
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
            expect_json_response_error
            expect(response_error["message"]).to eql(I18n.t("core.users/registrations.messages_error_registration_not_allowed"))
        else
            expect_json_response_error
            expect(response_error["message"]).to eql("error_password_cannot_be_blank")
        end
    end

    it "Try to create an user with mismatch password" do

        post :create, params: {
            user: {
                email: "random@lesli.cloud",
                paswword: "123",
                password_confirmation: "abc"
            }
        }

        unless @allow_registration
            expect_json_response_error
            expect(response_error["message"]).to eql(I18n.t("core.users/registrations.messages_error_registration_not_allowed"))
        else
            expect_json_response_error
            expect(response_error["message"]).to eql("error_password_cannot_be_blank")
        end
    end
end
