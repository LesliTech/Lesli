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


RSpec.describe "GET:/otp", type: :request do
    subject!(:response) { get "/otp.json" }
    it "is expected to redirect to '/otp/new' when the param 't' is not sent" do
        expect(response).to redirect_to("/otp/new")
    end
end

RSpec.describe "GET:/otp", type: :request do
    subject!(:response) do
        get "/otp.json", params: { t: Faker::Lorem.characters(number: 30) }   
    end

    it "is expected to redirect to '/login' when an invalid token is sent" do
        expect(response).to redirect_to("/login")
    end
end

RSpec.describe "GET:/otp", type: :request do
    
    include_context "request user authentication"

    it "is expected to redirect to root '/' if everything happened correctly" do
        otp = @current_user.access_codes.new({ token_type: "otp" })
        raw, enc = Devise.token_generator.generate_otp(otp.class, :token)
        otp.token = enc
        otp.save

        get "/otp.json", params: { t: raw }   

        expect(response).to redirect_to("/")
    end
end
