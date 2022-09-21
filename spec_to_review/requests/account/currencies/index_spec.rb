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


RSpec.describe "GET:/administration/account/currencies", type: :request do 
    include_context "user authentication"

    before(:all) do
        # delete all records to work with a clean table
        @user.account.currencies.destroy_all

        @new_currency = @user.account.currencies.new({
            name: Faker::Currency.name,
            symbol: Faker::Currency.symbol,
            country_alpha_3: Faker::Currency.code
        })

        @new_currency.user_main_id = @user.id
        @new_currency.users_id = @user.id
        @new_currency.save!

        get "/administration/account/currencies.json"
    end

    include_examples "successful standard json response"

    it "is expected to respond with all currencies saved in the DB" do 
        expect(@response_body_data).to be_a(Hash)

        expect(@response_body_data.keys).to contain_exactly("pagination", "records")

        expect(@response_body_data["pagination"]).to be_a(Hash)
        expect(@response_body_data["pagination"].keys).to contain_exactly("total_pages", "current_page", "count_total", "count_results")
        
        expect(@response_body_data["pagination"]["total_pages"]).to be_a(Numeric)
        expect(@response_body_data["pagination"]["total_pages"]).to eql(1)

        expect(@response_body_data["pagination"]["current_page"]).to be_a(Numeric)
        expect(@response_body_data["pagination"]["current_page"]).to eql(1)

        expect(@response_body_data["pagination"]["count_total"]).to be_a(Numeric)
        expect(@response_body_data["pagination"]["count_total"]).to eql(1)

        expect(@response_body_data["pagination"]["count_results"]).to be_a(Numeric)
        expect(@response_body_data["pagination"]["count_results"]).to eql(1)

        expect(@response_body_data["records"]).to be_an(Array)
        expect(@response_body_data["records"].length).to eql(1)

        expect(@response_body_data["records"].last).to be_a(Hash)

        expect(@response_body_data["records"].last).to have_key("created_at_date")
        expect(@response_body_data["records"].last["created_at_date"]).to be_a(String)

        expect(@response_body_data["records"].last).to have_key("updated_at_date")
        expect(@response_body_data["records"].last["updated_at_date"]).to be_a(String)

        expect(@response_body_data["records"].last).to have_key("created_at")
        expect(@response_body_data["records"].last["created_at"]).to be_a(String)

        expect(@response_body_data["records"].last).to have_key("id")
        expect(@response_body_data["records"].last["id"]).to be_a(Numeric)
        expect(@response_body_data["records"].last["id"]).to eql(@new_currency.id)

        expect(@response_body_data["records"].last).to have_key("name")
        expect(@response_body_data["records"].last["name"]).to be_a(String)
        expect(@response_body_data["records"].last["name"]).to eql(@new_currency.name)

        expect(@response_body_data["records"].last).to have_key("symbol")
        expect(@response_body_data["records"].last["symbol"]).to be_a(String)
        expect(@response_body_data["records"].last["symbol"]).to eql(@new_currency.symbol)

        expect(@response_body_data["records"].last).to have_key("country_alpha_3")
        expect(@response_body_data["records"].last["country_alpha_3"]).to be_a(String)
        expect(@response_body_data["records"].last["country_alpha_3"]).to eql(@new_currency.country_alpha_3)

        expect(@response_body_data["records"].last).to have_key("users_id")
        expect(@response_body_data["records"].last["users_id"]).to be_a(Numeric)
        expect(@response_body_data["records"].last["users_id"]).to eql(@user.id)

        expect(@response_body_data["records"].last).to have_key("user_main_id")
        expect(@response_body_data["records"].last["user_main_id"]).to eql(@user.id)

        expect(@response_body_data["records"].last).to have_key("valid_from_text")
        expect(@response_body_data["records"].last["valid_from_text"]).to be_nil

        expect(@response_body_data["records"].last).to have_key("valid_to_text")
        expect(@response_body_data["records"].last["valid_to_text"]).to be_nil

        expect(@response_body_data["records"].last).to have_key("descriptive_name")
        expect(@response_body_data["records"].last["descriptive_name"]).to be_a(String)
        expect(@response_body_data["records"].last["descriptive_name"]).to eql("#{@new_currency.country_alpha_3} (#{@new_currency.symbol})")
    end
end
