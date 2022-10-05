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


RSpec.describe "GET:/administration/account/options.json", type: :request, :unless => defined?(DeutscheLeibrenten) do
    include_context "request user authentication"

    # test cases
    it "is expected to respond with all the records from account settings" do
        get("/administration/account/options.json")
        
        # shared examples
        expect_response_with_successful

        expect(response_body).to be_a(Object)

        expect(response_body).to have_key("regions")
        expect(response_body["regions"]).to be_a(Object)

        expect(response_body).to have_key("time_zones")
        expect(response_body["time_zones"]).to be_a(Object)

        expect(response_body).to have_key("countries")
        expect(response_body["countries"]).to be_a(Object)

        expect(response_body).to have_key("days_into_week")
        expect(response_body["days_into_week"]).to be_a(Object)

    end

end
