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

RSpec.describe Users::ConfirmationsController, type: :controller do

    before :each do

        request.env["HTTP_ACCEPT"] = "text/html"
        request.env["devise.mapping"] = Devise.mappings[:user]

        # creates a new user for every test
        @password = "tardis2021$"
        @user = Account.first.users.create!({
            email: Faker::Internet.email,
            password: @password,
            password_confirmation: @password
        })

    end

    it "expect to create a user with confirmation token" do 
        expect(@user.confirmation_token).not_to be_nil
        expect(@user.confirmation_token).to be_kind_of(String)
    end

    it "try to confirm account with wrong token param" do

        get :show, params: { :wrong_confirmation_token_param => "" }

        expect(response).to have_http_status(:success)
        expect(response.content_type).to eq("text/html; charset=utf-8")

        expect(flash[:danger]).to be_present
        expect(flash[:danger]).to eql(I18n.t("core.users/confirmations.messages_warning_invalid_token"))

    end

    it "try to confirm account with no token" do

        get :show, params: { :confirmation_token => "" }

        expect(response).to have_http_status(:success)
        expect(response.content_type).to eq("text/html; charset=utf-8")

        expect(flash[:danger]).to be_present
        expect(flash[:danger]).to eql(I18n.t("core.users/confirmations.messages_warning_invalid_token"))

    end

    it "confirm account" do

        get :show, params: { :confirmation_token => @user.confirmation_token }

        expect(response).to have_http_status(:success)
        expect(response.content_type).to eq("text/html; charset=utf-8")

        expect(flash[:success]).to be_present
        expect(flash[:success]).to eql(I18n.t("core.users/confirmations.messages_success_email_updated"))

    end

end
