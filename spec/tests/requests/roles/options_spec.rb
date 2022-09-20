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

RSpec.describe 'GET:/administration/roles/options.json', type: :request, :unless => defined?(DeutscheLeibrenten) do

    include_context "request user authentication"

    it "is expected to respond with roles options" do

        get("/administration/roles/options.json")

        # shared examples
        expect_response_with_successful

        # custom specs
        expect(response_body).to be_a(Hash)

        expect(response_body).to have_key("object_level_permissions")
        expect(response_body["object_level_permissions"]).to be_an(Array)
        expect(response_body["object_level_permissions"].first).to be_a(Hash)

        expect(response_body["object_level_permissions"].first).to have_key("level")
        expect(response_body["object_level_permissions"].first["level"]).to be_a(Numeric)

        expect(response_body["object_level_permissions"].first).to have_key("roles")
        expect(response_body["object_level_permissions"].first["roles"]).to be_an(Array)
    end
end
