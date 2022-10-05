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

require "lesli_request_helper"

RSpec.describe 'GET:/administration/roles.json', type: :request, :unless => defined?(DeutscheLeibrenten) do

    include_context "request user authentication"

    it "is expected to respond with an index of roles" do

        role = FactoryBot.create(:role)

        user_role_level_max = @current_user.roles.map(&:object_level_permission).max()

        total = @current_user.account.roles.where("roles.object_level_permission <= ?", user_role_level_max).count

        get("/administration/roles.json")

        # shared examples
        expect_response_with_pagination

        # custom specs
        expect(response_body["pagination"]["total"]).to eql(total)

    end
end
