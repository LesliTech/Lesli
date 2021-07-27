=begin
    
Copyright (c) 2020, all rights reserved.

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

RSpec.shared_examples "successful standard json response" do   

    before :each do
        @response_body = JSON.parse(response.body)
        @response_body_data = @response_body["data"]
    end

    it "is expected to respond with a success status code (2xx)" do 
        expect(response).to have_http_status(:success) 
    end

    it "is expected to respond with application/json" do 
        expect(response.content_type).to eq("application/json; charset=utf-8")
    end

    it "is expected to respond with a successful property" do
        expect(@response_body).to have_key('successful') 
    end

    it "is expected to respond with successful" do
        expect(@response_body["successful"]).to eql(true)
    end

    it "is expected to respond with data" do
        expect(@response_body).to have_key("data")
    end

end
