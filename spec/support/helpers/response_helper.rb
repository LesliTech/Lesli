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

module ResponseHelpers

    @@response_json = nil

    def response_json
        @@response_json = JSON.parse(response.body) if @@response_json.blank?
        @@response_json 
    end

    def response_data
        response_json["data"]
    end

    def response_error
        response_json["error"]
    end

    def expect_json_response_successful
        @@response_json = nil
        expect(response).to have_http_status(:success)
        expect(response.content_type).to eq("application/json; charset=utf-8")
        expect(response_json).to have_key('successful') 
        expect(response_json["successful"]).to eql(true)
        expect(response_json).to have_key("data")
    end

    def expect_json_response_error
        @@response_json = nil
        expect(response).to have_http_status(:success) 
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(response_json).to have_key('successful') 
        expect(response_json['successful']).to eql(false)
        expect(response_json).to have_key('error') 
        expect(response_json["error"]).to have_key('message') 
    end

end
