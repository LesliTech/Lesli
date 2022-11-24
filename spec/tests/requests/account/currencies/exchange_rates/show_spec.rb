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

RSpec.describe "Tests for Lesli3", type: :request, :unless => defined?(DeutscheLeibrenten) do
    describe "GET:/administration/account/currencies/:currency_id/exchange_rates/:id", type: :request do
        include_context "request user authentication"

        it "is expected to respond with a exchange rate" do 
            @valid_from = Time.now
            @valid_to = Time.now 

            # create a valid currency
            @new_currency = @current_user.account.currencies.create!({
                name: Faker::Currency.name,
                symbol: Faker::Currency.symbol,
                country_alpha_3: Faker::Currency.code,
                user_main_id: @current_user.id,
                users_id: @current_user.id
            })

            @exchange_rates_params = {
                valid_from: @valid_from,
                valid_to: @valid_to,
                exchange_rate: Faker::Number.decimal(l_digits: 1, r_digits: 3)
            }

            @new_currency_exchange_rate = @current_user.account.currencies.find_by(id: @new_currency.id).exchange_rates.create!(@exchange_rates_params)

            get "/administration/account/currencies/#{@new_currency.id}/exchange_rates/#{@new_currency_exchange_rate.id}.json"

            expect_response_with_successful
            
            expect(response_body).to be_a(Hash)

            expect(response_body).to have_key("id")
            expect(response_body["id"]).to be_a(Numeric)

            expect(response_body).to have_key("exchange_rate")
            expect(response_body["exchange_rate"]).to be_a(String)
            expect(response_body["exchange_rate"].to_f).to eql(@exchange_rates_params[:exchange_rate])

            expect(response_body).to have_key("valid_from")
            expect(response_body["valid_from"]).to be_a(String)
            
            expect(response_body).to have_key("valid_to")
            expect(response_body["valid_to"]).to be_a(String)

            expect(response_body).to have_key("created_at")
            expect(response_body["created_at"]).to be_a(String)

            expect(response_body).to have_key("account_currencies_id")
            expect(response_body["account_currencies_id"]).to be_a(Numeric)
            expect(response_body["account_currencies_id"]).to eql(@new_currency.id)

            expect(response_body).to have_key("valid_from_text")
            expect(response_body["valid_from_text"]).to be_a(String)

            expect(response_body).to have_key("valid_to_text")
            expect(response_body["valid_to_text"]).to be_a(String)

            expect(response_body).to have_key("created_at_text")
            expect(response_body["created_at_text"]).to be_a(String)
        end

        it "is expected to return with a exchange rate not found" do 
            # this is a new currency, therefore does not have any exchange rate yet, no records
            @new_currency = @current_user.account.currencies.create!({
                name: Faker::Currency.name,
                symbol: Faker::Currency.symbol,
                country_alpha_3: Faker::Currency.code,
                user_main_id: @current_user.id,
                users_id: @current_user.id
            })

            #there is no currency with ID = 1, therefore should return with not found
            get "/administration/account/currencies/#{@new_currency.id}/exchange_rates/1.json"

    
            expect_response_with_not_found

            expect(response_body).to be_a(Hash)

            expect(response_body.keys).to contain_exactly("message")
            expect(response_body["message"]).to be_a(String)
        end
    end
end

