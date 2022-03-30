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

require "rails_helper"
require "spec_helper"
require "byebug"

RSpec.describe "GET:/administration/account/currencies/:id", type: :request do 

    include_context "user authentication"

    before(:all) do 
        @new_currency = @user.account.currencies.new({
            name: Faker::Currency.name,
            symbol: Faker::Currency.symbol,
            country_alpha_3: Faker::Currency.code
        })

        @new_currency.user_main_id = @user.id
        @new_currency.users_id = @user.id
        @new_currency.save!

        get "/administration/account/currencies/#{@new_currency.id}.json"
    end

    include_examples "successful standard json response"

    it "is expected to respond with an existing currency" do 
        expect(@response_body_data).to be_a(Hash)

        expect(@response_body_data).to have_key("id")
        expect(@response_body_data["id"]).to be_a(Numeric)
        expect(@response_body_data["id"]).to eql(@new_currency.id)

        expect(@response_body_data).to have_key("name")
        expect(@response_body_data["name"]).to be_a(String)
        expect(@response_body_data["name"]).to eql(@new_currency.name)

        expect(@response_body_data).to have_key("symbol")
        expect(@response_body_data["symbol"]).to be_a(String)
        expect(@response_body_data["symbol"]).to eql(@new_currency.symbol)

        expect(@response_body_data).to have_key("country_alpha_3")
        expect(@response_body_data["country_alpha_3"]).to be_a(String)
        expect(@response_body_data["country_alpha_3"]).to eql(@new_currency.country_alpha_3)

        expect(@response_body_data).to have_key("user_main_id")
        expect(@response_body_data["user_main_id"]).to be_a(Numeric)
        expect(@response_body_data["user_main_id"]).to eql(@user.id)

        expect(@response_body_data).to have_key("deleted_at")
        expect(@response_body_data["deleted_at"]).to be_nil

        expect(@response_body_data).to have_key("created_at")
        expect(@response_body_data["created_at"]).to be_a(String)

        expect(@response_body_data).to have_key("updated_at")
        expect(@response_body_data["updated_at"]).to be_a(String)

        expect(@response_body_data).to have_key("users_id")
        expect(@response_body_data["users_id"]).to be_a(Numeric)
        expect(@response_body_data["users_id"]).to eql(@user.id)

        expect(@response_body_data).to have_key("accounts_id")
        expect(@response_body_data["accounts_id"]).to be_a(Numeric)
        expect(@response_body_data["accounts_id"]).to eql(@user.account.id)
    end
end

RSpec.describe "GET:/administration/account/currencies/:id", type: :request do 

    include_context "user authentication"

    before(:all) do 
        # Set currency id that does not exist
        @invalid_currency_id = @user.account.currencies.all.order(id: :asc).last["id"] + 1

        get "/administration/account/currencies/#{@invalid_currency_id}.json"

    end

    include_examples "not found standard json response"

    it "is expected to respond with a currency not found when an invalid id is sent" do 
        expect(@response_body).to have_key("error")
        expect(@response_body["error"]).to be_a(Hash)

        expect(@response_body["error"]).to have_key("message")
        expect(@response_body["error"]["message"]).to be_a(String)
        
        expect(@response_body["error"]).to have_key("details")
        expect(@response_body["error"]["details"]).to be_a(Array)
    end

end
