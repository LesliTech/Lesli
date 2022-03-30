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

RSpec.describe "DELETE:/administration/users/:id/roles/:id", type: :request do
    include_context "request user authentication"

    # helper methods
    
    let(:limited_user) do
        @new_user = User.new(attributes_for(:user))
        @account = create(:account)
        @role = Role.find_by(name: "limited")

        @new_user.account = @account
        @new_user.confirm
        @new_user.save!

        @new_user.user_roles.create!({ role: @role })
        @new_user
    end

    

    # it "is expected to respond with unauthorized when is trying to destory a user's role" do
    #     @role = create(:role, accounts_id: @current_user.account.id)
    #     @user_role = @current_user.user_roles.create!({ role: @role })

    #     delete "/administration/users/#{@current_user.id}/roles/#{@role.id}.json"

    #     # shared examples
    #     expect_json_response_successful
    # end

    it "is expected to respond with unauthorized" do
        # We create and sign in a limited user
        limited_user
        sign_in @new_user


        delete "/administration/users/#{@current_user.id}/roles/0.json"

        # shared examples
        expect_json_response_unauthorized
    end

    it "is expected to redirect to login when no user is authenticated" do
        # We create and sign in a limited user
        sign_out @current_user


        delete "/administration/users/#{@current_user.id}/roles/0.json"

        # specific specs
        expect(response).to redirect_to("/login")
    end

end