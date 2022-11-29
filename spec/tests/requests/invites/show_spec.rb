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

RSpec.describe "Get:/invite", type: :request do
    
    include_context "request user authentication"
    
    it "returns a successfull response" do
        get("/invite")
        expect(response).to have_http_status(:ok)
        expect(response.status).to eq(200)
    end
    
    it "returns a content type to be text/html" do
        get("/invite")
        expect(response.content_type).to eq "text/html; charset=utf-8"
    end
    
    it "renders a right template" do
        get("/invite")
        expect(response).to render_template(:show)
    end
    
    it "does not render a different template" do
        get("/invite")
        expect(response).to_not render_template(:post)
    end  
    
end