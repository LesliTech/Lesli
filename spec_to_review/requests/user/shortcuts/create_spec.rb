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
    let(:shortcut_params) { attributes_for(:shortcut) }
    let(:invalid_params) { attributes_for(:invalid_shortcut) }
    let(:shortcut_nil_params) { attributes_for(:shortcut_nil_params) }



    it "is expected to create a new shortcut successfuly" do

        post "/administration/users/#{@current_user.id}/shortcuts.json", params: {  user_shortcut: shortcut_params }

        # shared examples
        expect_json_response_successful

        # specific specs
        expect(response_data).to be_a(Hash)
        expect(response_data).to have_key("id")
        expect(response_data["id"]).to be_a(Numeric)
        expect(response_data["id"]).to be >= 1
        
        expect(response_data).to have_key("name")
        expect(response_data["name"]).to be_a(String)
        expect(response_data["name"]).to eql(shortcut_params[:name]) # At least the name should be created
    end

    it "is expected to respond with error when params are invalid" do

        post "/administration/users/#{@current_user.id}/shortcuts.json", params: {  user_shortcut: invalid_params }

        #shared examples
        expect_json_response_error
    end

    it "is expected to respond with error when params are nil" do

        post "/administration/users/#{@current_user.id}/shortcuts.json", params: {  user_shortcut: shortcut_nil_params }

        #shared examples
        expect_json_response_error
    end

    it "is expected to redirect to login when no user is authenticated" do
        sign_out @current_user

        post "/administration/users/#{@current_user.id}/shortcuts.json", params: {  user_shortcut: shortcut_params }

        # specific specs
        expect(response).to redirect_to("/login")
    end

end