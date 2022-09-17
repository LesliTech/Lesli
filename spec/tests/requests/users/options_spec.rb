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


RSpec.describe "GET:/administration/users/options.json", type: :request, :unless => defined?(DeutscheLeibrenten) do
    include_context "request user authentication"

    # test cases
    it "is expected to respond with all the options from users" do
        get("/administration/users/options.json")
        
        # shared examples
        expect_response_with_successful

        expect(response_body).to be_a(Object)

        expect(response_body).to have_key("roles")
        expect(response_body["roles"].length).to be >0

        expect(response_body).to have_key("salutations")
        expect(response_body["salutations"].length).to be >0

        expect(response_body).to have_key("locales")
        expect(response_body["locales"].length).to be >0

        expect(response_body).to have_key("mfa_methods")
        expect(response_body["mfa_methods"].length).to be >0

    end

end
