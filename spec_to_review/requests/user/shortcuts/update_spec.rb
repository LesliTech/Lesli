=begin

Copyright (c) 2022, all rights reserved.

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


require 'lesli_request_helper'
require 'spec_helper'   
require 'byebug'


RSpec.describe "POST:/administration/users/:id/shortcuts.json", type: :request do
    include_context "request user authentication"

    # helper methods
    let!(:shortcut_params) { attributes_for(:shortcut) }
    let(:invalid_params) { attributes_for(:invalid_shortcut) }
    let(:shortcut_nil_params) { attributes_for(:shortcut_nil_params) }

    let(:shortcut) do
        title_prefix = Rails.application.config.lesli.dig(:account, :website, :title_prefix)
        shortcut_name = (shortcut_params[:name]).gsub("#{ title_prefix } · ", "")

        @user_shortcut = @current_user.shortcuts
        .create_with(name: shortcut_name)
        .find_or_create_by(url: shortcut_params[:url])

        @user_shortcut.save!
        @user_shortcut
    end



    it "is expected to respond with a user_shortcut updated successfuly" do
        # we create a new user_shorcut to work with
        shortcut

        put "/administration/users/#{@current_user.id}/shortcuts/#{@user_shortcut.id}.json", params: { user_shortcut: shortcut_params }

        # shared examples
        expect_json_response_successful

        # specific specs
        expect(response_data).to be_a(Hash)
        expect(response_data).to have_key("name")
        expect(response_data["name"]).to be_a(String)
        expect(response_data["name"]).to eql(shortcut_params[:name])
    end

    it "is expected to respond with error when params are invalid" do
        # we create a new user_shorcut to work with
        shortcut

        put "/administration/users/#{@current_user.id}/shortcuts/#{@user_shortcut.id}.json", params: { user_shortcut: invalid_params }

        # shared examples
        expect_json_response_error
    end


    it "is expected to respond with error when params are nil" do
        # we create a new user_shorcut to work with
        shortcut

        put "/administration/users/#{@current_user.id}/shortcuts/#{@user_shortcut.id}.json", params: { user_shortcut: shortcut_nil_params }

        # shared examples
        expect_json_response_error
    end

    it "is expected to redirect to login when user no user is authenticated" do
        # we create a new user_shorcut to work with
        shortcut

        # We ensure that there is not authenticated user
        sign_out @current_user

        put "/administration/users/#{@current_user.id}/shortcuts/#{@user_shortcut.id}.json", params: { user_shortcut: shortcut_params } 

        # specific specs
        expect(response).to redirect_to("/login")
    end

end
