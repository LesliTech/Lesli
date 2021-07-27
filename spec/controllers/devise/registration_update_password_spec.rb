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
require 'byebug'

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

    def prepare_password_settings
        Account.first.settings.where(name: 'password_minimum_length').update(value: 6)
        Account.first.settings.where(name: 'password_enforce_complexity').update(value: 1)
        Account.first.settings.where(name: 'password_special_char_count').update(value: 0)
        Account.first.settings.where(name: 'password_uppercase_count').update(value: 0)
        Account.first.settings.where(name: 'password_lowercase_count').update(value: 0)
        Account.first.settings.where(name: 'password_digit_count').update(value: 0)
    end

    before :each do
        request.env["devise.mapping"] = Devise.mappings[:user]
        sign_in(User.find_by(email: "test@lesli.cloud"))
        prepare_password_settings
    end

    after :each do 
        prepare_password_settings
    end

    describe "update password with no minimum length" do

        before :each do
            @password = "abcde"
            put :update, params: {
                user: {
                    password: @password,
                    password_confirmation: @password
                }
            }
        end

        include_examples 'error standard json response'

        it "is expected to respond with error message" do
            expect(@response_body_error['message'][0]).to eql('error_password_minimum_length')
        end

    end

    describe "update password with minimum length" do

        before :each do
            @password = "abcde12345"
            put :update, params: {
                user: {
                    password: @password,
                    password_confirmation: @password
                }
            }
        end

        include_examples 'successful standard json response'

    end

    describe "update password with special characters required" do

        before :each do
            @password = "abcdef12345"
            Account.first.settings.where(name: 'password_special_char_count').update(value: 1)
            put :update, params: {
                user: {
                    password: @password,
                    password_confirmation: @password
                }
            }
        end

        include_examples 'error standard json response'

        it "is expected to respond with error message" do
            expect(@response_body_error['message'][0]).to eql('error_password_special_char_count')
        end

    end

    describe "update password sending special characters required" do

        before :each do
            @password = "abcde1234$"
            Account.first.settings.where(name: 'password_special_char_count').update(value: 1)
            put :update, params: {
                user: {
                    password: @password,
                    password_confirmation: @password
                }
            }
        end

        include_examples 'successful standard json response'

    end

    describe "update password with uppercase letters required" do

        before :each do
            @password = "abcdef12345"
            Account.first.settings.where(name: 'password_uppercase_count').update(value: 1)
            put :update, params: {
                user: {
                    password: @password,
                    password_confirmation: @password
                }
            }
        end

        include_examples 'error standard json response'

        it "is expected to respond with error message" do
            expect(@response_body_error['message'][0]).to eql('error_password_uppercase_count')
        end

    end

    describe "update password sending uppercase letters required" do

        before :each do
            @password = "Abcde1234$"
            Account.first.settings.where(name: 'password_uppercase_count').update(value: 1)
            put :update, params: {
                user: {
                    password: @password,
                    password_confirmation: @password
                }
            }
        end

        include_examples 'successful standard json response'

    end

    context "update password sending uppercase letters required" do

        before :each do
            @password = "Abcde1234$"
            Account.first.settings.where(name: 'password_uppercase_count').update(value: 1)
            put :update, params: {
                user: {
                    password: @password,
                    password_confirmation: @password
                }
            }
        end

        include_examples 'successful standard json response'

    end

end
