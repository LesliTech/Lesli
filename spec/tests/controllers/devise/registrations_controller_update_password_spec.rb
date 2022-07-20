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
require "lesli_controller_helper"


RSpec.describe Users::RegistrationsController, type: :controller do

    include_context 'controller user authentication'

    def prepare_password_settings
        Account.first.settings.where(name: 'password_minimum_length').update(value: 6)
        Account.first.settings.where(name: 'password_enforce_complexity').update(value: 1)
        Account.first.settings.where(name: [
            "password_special_char_count",
            "password_uppercase_count",
            "password_lowercase_count",
            "password_digit_count"
        ]).update(value: 0)
    end

    before :each do
        prepare_password_settings
    end

    after :each do 
        prepare_password_settings
    end

    it "try to update password with no minimum length" do

        password = "abcde"
        put :update, params: {
            user: {
                password: password,
                password_confirmation: password
            }
        }
        expect_response_with_error
        expect(response_body['message'][0]).to eql('error_password_minimum_length')
    end

    it "update password with minimum length" do

        password = "abcde12345"
        put :update, params: {
            user: {
                password: password,
                password_confirmation: password
            }
        }

        expect_response_with_successful

    end

    it "try update password with special characters required" do

        Account.first.settings.where(name: 'password_special_char_count').update(value: 1)
        password = "abcdef12345"
        put :update, params: {
            user: {
                password: password,
                password_confirmation: password
            }
        }

        expect_response_with_error
        expect(response_body["message"][0]).to eql('error_password_special_char_count')

    end


    it "update password sending special characters required" do

        password = "abcde1234$"
        Account.first.settings.where(name: 'password_special_char_count').update(value: 1)
        put :update, params: {
            user: {
                password: password,
                password_confirmation: password
            }
        }

        expect_response_with_successful

    end

    it "try update password with uppercase letters required" do

        password = "abcdef12345"
        Account.first.settings.where(name: 'password_uppercase_count').update(value: 1)
        put :update, params: {
            user: {
                password: password,
                password_confirmation: password
            }
        }

        expect_response_with_error
        expect(response_body['message'][0]).to eql('error_password_uppercase_count')

    end

    it "update password sending uppercase letters required" do

        password = "Abcde1234$"
        Account.first.settings.where(name: 'password_uppercase_count').update(value: 1)
        put :update, params: {
            user: {
                password: password,
                password_confirmation: password
            }
        }
    
        expect_response_with_successful

    end

    it "update password sending uppercase letters required" do

        password = "Abcde1234$"
        Account.first.settings.where(name: 'password_uppercase_count').update(value: 1)
        put :update, params: {
            user: {
                password: password,
                password_confirmation: password
            }
        }
    
        expect_response_with_successful

    end

end
