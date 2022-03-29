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

RSpec.describe "POST:/administration/users/:id/roles.json", type: :request do
    include_context "request user authentication"

    # helper methods
    def role(account_id)
        create(:role, accounts_id: account_id)
    end

    let(:current_user_roles) { User.find(@current_user.id).roles }

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



    it "is expected to assign a new role to a specific user" do
=begin
        post("/administration/users/#{@current_user.id}/roles.json", params: {
            user_role: { id: role(@current_user.account.id).id }
        })

        # shared examples
        expect_json_response_successful

        # expectations of the response
        expect(response_data.length).to eql(current_user_roles.length)
=end
    end

    it "is expected to return with error when user is not authorized" do
        # We create and sign in a limited user
        limited_user
        sign_in @new_user

        # We get the maximum level of permission and create according to the roles of users
        @max_level_permission = Role.select("object_level_permission").max().object_level_permission
        @role =  create(:role, accounts_id: @new_user.account.id, object_level_permission: @max_level_permission)
        

        post("/administration/users/#{@new_user.id}/roles.json", params: {
            user_role: { id: @role.id }
        })

        # shared examples
        expect_json_response_unauthorized
    end

    it "is expected to redirec to login when user is not authenticated" do
        sign_out @current_user

        post("/administration/users/#{@current_user.id}/roles.json", params: {
            user_role: { id: role(@current_user.account.id).id }
        })

        
        # custom expectations
        expect(response).to redirect_to("/login")
    end

end
