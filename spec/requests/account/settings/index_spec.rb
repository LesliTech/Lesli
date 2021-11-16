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

RSpec.describe "GET:/administration/account/settings", type: :request do

    include_context 'user authentication'

    before(:all) do 
        @name = "testing"
        @value = "%d.%m.%Y"

        @new_setting = @user.account.settings.create!({
            name: @name,
            value: @value
        })

        get "/administration/account/settings.json"
    end

    include_examples 'successful standard json response'

    it "is expected to return with account settings" do 
        expect(@response_body_data).to be_an(Array)
        expect(@response_body_data.length).to be > 0

        expect(@response_body_data.last).to be_a(Hash)
        expect(@response_body_data.last.keys).to contain_exactly("id", "name", "value", "created_at", "updated_at", "accounts_id")

        expect(@response_body_data.last["id"]).to be_a(Numeric)
        expect(@response_body_data.last["id"]).to eql(@new_setting.id)
        
        expect(@response_body_data.last["name"]).to be_a(String)
        expect(@response_body_data.last["name"]).to eql(@new_setting.name)

        expect(@response_body_data.last["value"]).to be_a(String)
        expect(@response_body_data.last["value"]).to eql(@new_setting.value)

        expect(@response_body_data.last["created_at"]).to be_a(String)

        expect(@response_body_data.last["updated_at"]).to be_a(String)

        expect(@response_body_data.last["accounts_id"]).to be_a(Numeric)
        expect(@response_body_data.last["accounts_id"]).to eql(@user.account.id)
    end

end