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

# DO NOT FORGET TO DELETE ALL COMMENTED CODE WHEN THE RESPECTIVE ISSUES ARE RESOLVED

require "lesli_request_helper"

RSpec.describe "POST:/otp", type: :request do
    it "is expected to respond with data equal to nil, when email is not sent" do
        post("/otp")
        expect_response_with_successful
        expect(response_body).to eql({})
    end

    it "is expected to respond with otp" do
        post("/otp.json", params: { email: User.first()[:email] })
        expect_response_with_successful
        expect(response_body).to be_a(String)
    end
end 
