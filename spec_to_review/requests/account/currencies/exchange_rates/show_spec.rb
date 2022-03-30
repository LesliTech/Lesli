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

RSpec.describe "GET:/administration/account/currencies/:currency_id/exchange_rates/:id", type: :request do 
    include_context "user authentication"

    before(:all) do 
        @valid_from = Time.now
        @valid_to = Time.now 

        # create a valid currency
        @new_currency = @user.account.currencies.create!({
            name: Faker::Currency.name,
            symbol: Faker::Currency.symbol,
            country_alpha_3: Faker::Currency.code,
            user_main_id: @user.id,
            users_id: @user.id
        })

        @exchange_rates_params = {
            valid_from: @valid_from,
            valid_to: @valid_to,
            exchange_rate: Faker::Number.decimal(l_digits: 1, r_digits: 3)
        }

        @new_currency_exchange_rate = @user.account.currencies.find_by(id: @new_currency.id).exchange_rates.create!(@exchange_rates_params)

        get "/administration/account/currencies/#{@new_currency.id}/exchange_rates/#{@new_currency_exchange_rate.id}.json"
    end

    include_examples "successful standard json response"

    it "is expected to respond with a exchange rate" do 
        expect(@response_body_data).to be_a(Hash)

        expect(@response_body_data).to have_key("id")
        expect(@response_body_data["id"]).to be_a(Numeric)

        expect(@response_body_data).to have_key("exchange_rate")
        expect(@response_body_data["exchange_rate"]).to be_a(String)
        expect(@response_body_data["exchange_rate"].to_f).to eql(@exchange_rates_params[:exchange_rate])

        expect(@response_body_data).to have_key("valid_from")
        expect(@response_body_data["valid_from"]).to be_a(String)
        expect(LC::Date2.new(Time.parse(@response_body_data["valid_from"])).date_time.to_s).to eql(LC::Date2.new(@valid_from).date_time.to_s)
        
        expect(@response_body_data).to have_key("valid_to")
        expect(@response_body_data["valid_to"]).to be_a(String)
        expect(LC::Date2.new(Time.parse(@response_body_data["valid_to"])).date_time.to_s).to eql(LC::Date2.new(@valid_to).date_time.to_s)

        expect(@response_body_data).to have_key("created_at")
        expect(@response_body_data["created_at"]).to be_a(String)

        expect(@response_body_data).to have_key("account_currencies_id")
        expect(@response_body_data["account_currencies_id"]).to be_a(Numeric)
        expect(@response_body_data["account_currencies_id"]).to eql(@new_currency.id)

        expect(@response_body_data).to have_key("valid_from_text")
        expect(@response_body_data["valid_from_text"]).to be_a(String)

        expect(@response_body_data).to have_key("valid_to_text")
        expect(@response_body_data["valid_to_text"]).to be_a(String)

        expect(@response_body_data).to have_key("created_at_text")
        expect(@response_body_data["created_at_text"]).to be_a(String)
    end
end

RSpec.describe "GET:/administration/account/currencies/:currency_id/exchange_rates/:id", type: :request do 
    include_context "user authentication"

    before(:all) do 
        # this is a new currency, therefore does not have any exchange rate yet, no records
        @new_currency = @user.account.currencies.create!({
            name: Faker::Currency.name,
            symbol: Faker::Currency.symbol,
            country_alpha_3: Faker::Currency.code,
            user_main_id: @user.id,
            users_id: @user.id
        })

        #there is no currency with ID = 1, therefore should return with not found
        get "/administration/account/currencies/#{@new_currency.id}/exchange_rates/1.json"
    end

    include_examples "not found standard json response"

    it "is expected to return with a exchange rate not found" do 
        expect(@response_body).to be_a(Hash)

        expect(@response_body).to have_key("error")
        expect(@response_body["error"].keys).to contain_exactly("message", "details")
        
        expect(@response_body["error"]["message"]).to be_a(String)
        expect(@response_body["error"]["details"]).to be_an(Array)
    end
end