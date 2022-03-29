=begin

Copyright (c) 2021, all rights reserved.

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


require "lesli_request_helper"


RSpec.describe "POST:/administration/users/:id/settings.json", type: :request do
    include_context "request user authentication"

    # helper methods
    let(:user_setting_params) { attributes_for(:user_setting) }
    let(:invalid_setting_params) { attributes_for(:invalid_user_setting) }
    let(:user_setting_nil_params) { attributes_for(:user_setting_nil_params) }

    # test cases
    it "is expected to test the creation of the record" do
        post("/administration/users/#{@current_user.id}/settings.json", params: {
            user_setting: user_setting_params
        })

        # shared examples
        expect_json_response_successful

        # custom expects
        expect(response_data).to have_key("id")
        expect(response_data["id"]).to be >= 1

        expect(response_data).to have_key("name")
        expect(response_data["name"]).to eql(user_setting_params[:name])

        expect(response_data).to have_key("value")
        expect(response_data["value"]).to eql(user_setting_params[:value])

        expect(response_data).to have_key("users_id")
        expect(response_data["users_id"]).to eql(@current_user.id)
    end

    it "is expected respond with error when params are invalid" do
        post("/administration/users/#{@current_user.id}/settings.json", params: {
            user_setting: invalid_setting_params
        })

        # shared examples
        expect_json_response_error
    end

    it "is expected respond with error when params are nil" do
        post("/administration/users/#{@current_user.id}/settings.json", params: {
            user_setting: user_setting_nil_params
        })

        # shared examples
        expect_json_response_error
    end

    it "is expected to redirect to login when no user is authenticated" do
        login = "/login"
        
        # we ensure that no one user is authenticated
        sign_out @current_user

        post("/administration/users/#{@current_user.id}/settings.json", params: {
            user_setting: {}
        })

        # custom expects
        expect(response).to redirect_to(login)
    end

end
