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

require "lesli_request_helper"

RSpec.describe 'POST:/pass', type: :request do

    it 'is expected to reject pass from unknown user' do
        post("/pass.json", params: {
            email: Faker::Internet.email
        })
        expect_response_with_successful
        expect(response_body).to eql({})
    end

    it "is expected to reject when no email is sent" do
        post("/pass.json", params: {})
        expect_response_with_successful
        expect(response_body).to eql({})
    end

    it "is expected to respond with a pass created" do
        post("/pass.json", params: { email: "test@lesli.cloud" })
        expect_response_with_successful
        expect(response_body).to eql({})
    end

end
