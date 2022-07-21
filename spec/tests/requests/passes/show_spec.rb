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

RSpec.describe "GET:/pass", type: :request, :unless => defined?(DeutscheLeibrenten) do
    
    it "is expected to render the pass request page" do
        get("/pass")
        expect(response).to have_http_status(:success)
    end

    it "is expected to redirect to '/login' when the token is invalid" do
        get("/pass", params: { t: Faker::Lorem.characters(number: 30) })
        expect(response).to redirect_to("/login")
    end

    it "is expected to redirect to root '/' if everything happened correctly" do
        pass = User.first.access_codes.new({ token_type: "pass" })
        raw, enc = Devise.token_generator.generate(pass.class, :token)
        pass.token = enc
        pass.save

        get("/pass", params: { t: raw })
        expect(response).to redirect_to("/")
    end
end
