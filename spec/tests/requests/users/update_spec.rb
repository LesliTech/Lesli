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


# require "lesli_request_helper"

# RSpec.describe "POST /administration/users/:id/roles", type: :request do
#     include_context "request user authentication"

#     # helper methods
#     let!(:create_user) { FactoryBot.create(:user, role_name: "limited") }

#     # test cases
#     it "Add sysadmin role to user" do
#         @test_user = create_user
#         @user_role_level_max = @test_user.roles.map(&:object_level_permission).max()
#         @admin_role_olp = Role.find_by(:name => "sysadmin").object_level_permission

#         sign_in @test_user

#         post("/administration/users/#{@test_user.id}/roles.json", params: {
#             user_role: {
#                 id: @test_user.account.roles.find_by(name: "sysadmin").id
#             }
#         })

#         if @user_role_level_max > @admin_role_olp
#             puts "true"
#             expect(response_json["successful"]).to eql(true)
#         else
#             puts "false"
#             puts response_json
#             expect(response_json["successful"]).to eql(false)
#         end
#     end
# end
