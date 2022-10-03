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

RSpec.describe 'DELETE:/administration/roles.json', type: :request, :unless => defined?(DeutscheLeibrenten) do

    include_context "request user authentication"

    it "is expected to have deleted a role successfully" do

        role = FactoryBot.create(:role)

        delete("/administration/roles/#{role.id}.json")

        # shared examples
        expect_response_with_successful

        # custom specs
        expect(response_body).to eq({})

    end

    it "is expected to respond with error when a role does not exist" do

        delete("/administration/roles/#{ 0 }.json")

        # shared examples
        expect_response_with_not_found

    end
end
