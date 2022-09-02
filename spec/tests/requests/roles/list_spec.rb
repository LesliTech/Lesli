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

RSpec.describe 'GET:/administration/roles/list.json', type: :request do

    include_context "request user authentication"

    it 'is expected to respond with the roles the user has level to work with' do

        FactoryBot.create(:role)

        roles_count = @current_user.account.roles
        .where("object_level_permission <= ?", @current_user.roles.map(&:object_level_permission).max())
        .count

        
        get("/administration/roles/list.json")

        # shared examples
        expect_response_with_successful

        # custom specs
        expect(response_body).to be_an(Array)
        expect(response_body.count).to eql(roles_count)

        expect(response_body.first).to be_a(Hash)
        expect(response_body.first).to have_key("id")
        expect(response_body.first["id"]).to be_a(Numeric)

        expect(response_body.first).to have_key("name")
        expect(response_body.first["name"]).to be_a(String)

        expect(response_body.first).to have_key("object_level_permission")
        expect(response_body.first["object_level_permission"]).to be_a(Numeric)
    end
end
