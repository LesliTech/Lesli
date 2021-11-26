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


RSpec.describe "GET:/onboarding", type: :request do 

    include_context "user authentication" 

    let!(:account) { JSON.parse(@user.account.to_json) }
    let!(:settings) { JSON.parse(@user.account.settings.order(id: :asc).to_json) }

    before(:all) do
        @new_setting = @user.account.settings.create!(name: Faker::Lorem.word, value: Faker::Lorem.word)
        
        get "/onboarding.json"
    end
    
    include_examples 'successful standard json response'

    it "is expected to respond with account and account_settings properties" do
        expect(@response_body_data).to be_a(Hash)
        expect(@response_body_data.keys).to contain_exactly("account", "account_settings")

        expect(@response_body_data["account"]).to be_a(Hash)
        expect(@response_body_data["account_settings"]).to be_an(Array)
    end

    it "is expected that the account returned has the same properties as the current account" do
        expect(@response_body_data["account"].keys).to match_array account.keys
    end

    it "is expected that the last account's setting matches with the created" do
        expect(settings.last.keys).to match_array JSON.parse(@new_setting.to_json).keys

        expect(settings.last["id"]).to be_a(Numeric)
        expect(settings.last["id"]).to eql(@new_setting.id)

        expect(settings.last["name"]).to be_a(String)
        expect(settings.last["name"]).to eql(@new_setting.name)

        expect(settings.last["value"]).to be_a(String)
        expect(settings.last["value"]).to eql(@new_setting.value)

        expect(settings.last["created_at"]).to be_a(String)
        expect(settings.last["updated_at"]).to be_a(String)
    end
end

RSpec.describe "GET:/onboardings", type: :request do
    before(:all) do
        get "/onboarding.json"
    end

    it "is expected to redirect to '/login?r=/onboarding.json' when user is not authenticated" do
        expect(response).to redirect_to("/login?r=/onboarding.json")
    end
end