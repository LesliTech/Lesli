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
    let(:user_shortcut) { User.find_by(id: @current_user.id).shortcuts.find_by(id: @user_shortcut.id) }
    let!(:shortcut_params) { attributes_for(:shortcut) }

    let(:shortcut) do
        title_prefix = Rails.application.config.lesli["account"]["website"]["title_prefix"] || ""
        shortcut_name = (shortcut_params[:name]).gsub("#{ title_prefix } · ", "")

        @user_shortcut = @current_user.shortcuts
        .create_with(name: shortcut_name)
        .find_or_create_by(url: shortcut_params[:url])

        @user_shortcut.save!
        @user_shortcut
    end



    it "is expected to destroy a user_shortcut successfuly" do
        # we create a new user_shorcut to work with
        shortcut

        delete "/administration/users/#{@current_user.id}/shortcuts/#{@user_shortcut.id}.json"

        # shared examples
        expect_json_response_successful

        # specific specs
        expect(response_data).to be_nil

        expect(user_shortcut).to be_nil
    end

    it "is expected to respond with not found when an invalid user_shortcut in given" do
        shortcut # should exist at leat one record in the DB
        @invalid_shortcut_id = User::Shortcut.all.order(id: :asc).last[:id] + 1

        delete "/administration/users/#{@current_user.id}/shortcuts/#{@invalid_shortcut_id}.json"

        # shared examples
        expect_json_response_not_found
    end

    it "is expected to redirect to login when no user is authenticated" do
        # we create a new user_shorcut to work with
        shortcut

        # We ensure that there is not authenticated user
        sign_out @current_user

        delete "/administration/users/#{@current_user.id}/shortcuts/#{@user_shortcut.id}.json"

        # specific specs
        expect(response).to redirect_to("/login")

    end

end
