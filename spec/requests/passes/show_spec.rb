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


require 'rails_helper'
require 'spec_helper'
require 'byebug'

RSpec.describe "GET:/pass", type: :request do
    subject!(:response) { get "/pass.json" }

    it "is expected to redirect to '/pass/new' when the token is not sent" do
        expect(response).to redirect_to("/pass/new")
    end
end

RSpec.describe "GET:/pass", type: :request do
    before(:all) do 
        get "/pass.json", params: { t: Faker::Lorem.characters(number: 30) }
    end

    it "is expected to redirect to '/login' when the token is invalid" do
        expect(response).to redirect_to("/login")
    end
end

RSpec.describe "GET:/pass", type: :request do
    include_context "user authentication"

    before(:all) do
        pass = @user.access_codes.new({ token_type: "pass" })
        raw, enc = Devise.token_generator.generate(pass.class, :token)
        pass.token = enc
        pass.save

        get "/pass.json", params: { t: raw }
    end

    it "is expected to redirect to root '/' if everything happened correctly" do
        expect(response).to redirect_to("/")
    end
end