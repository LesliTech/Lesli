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
    describe "PUT:/administration/account/currencies/:currency_id/exchange_rates/:id", type: :request do
        include_context "request user authentication"

        it "is expected to respond with an exchange rate updated completely with the PUT verb" do 
            @current_user.account.currencies.destroy_all
            @new_valid_from = Time.now
            @new_valid_to = Time.now

            # create a valid currency
            @new_currency = @current_user.account.currencies.create!({
                name: Faker::Currency.name,
                symbol: Faker::Currency.symbol,
                country_alpha_3: Faker::Currency.code,
                user_main_id: @current_user.id,
                users_id: @current_user.id
            })
            
            # create a exchange rate that will be updated
            @exchange_rate = {
                valid_from: Time.now,
                valid_to: Time.now,
                exchange_rate: Faker::Number.decimal(l_digits: 1, r_digits: 3)
            }

            @currency_exchange_rate = @current_user.account.currencies.find_by(id: @new_currency.id).exchange_rates.create!(@exchange_rate)

            @new_data = {
                valid_from: @new_valid_from,
                valid_to: @new_valid_to,
                exchange_rate: Faker::Number.decimal(l_digits: 1, r_digits: 3)
            }

            put("/administration/account/currencies/#{@new_currency.id}/exchange_rates/#{@currency_exchange_rate.id}.json", params: {
                currency_exchange_rate: @new_data
            })

            expect_response_with_successful
            
            expect(response_body).to be_a(Hash)

            expect(response_body).to have_key("id")
            expect(response_body["id"]).to be_a(Numeric)
            expect(response_body["id"]).to eql(@currency_exchange_rate.id)

            expect(response_body).to have_key("exchange_rate")
            expect(response_body["exchange_rate"]).to be_a(String)
            expect(response_body["exchange_rate"].to_f).to eql(@new_data[:exchange_rate])

            expect(response_body).to have_key("valid_from")
            expect(response_body["valid_from"]).to be_a(String)
            expect(LC::Date2.new(Time.parse(response_body["valid_from"])).date_time.to_s).to eql(LC::Date2.new(@new_valid_from).date_time.to_s)

            expect(response_body).to have_key("valid_to")
            expect(response_body["valid_to"]).to be_a(String)
            expect(LC::Date2.new(Time.parse(response_body["valid_to"])).date_time.to_s).to eql(LC::Date2.new(@new_valid_to).date_time.to_s)

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

        it "is expected to respond with an exchange rate updated completely with the PATCH verb" do 
            @current_user.account.currencies.destroy_all
            @new_valid_from = Time.now
            @new_valid_to = Time.now

            # create a valid currency
            @new_currency = @current_user.account.currencies.create!({
                name: Faker::Currency.name,
                symbol: Faker::Currency.symbol,
                country_alpha_3: Faker::Currency.code,
                user_main_id: @current_user.id,
                users_id: @current_user.id
            })
            
            # create a exchange rate that will be updated
            @exchange_rate = {
                valid_from: Time.now,
                valid_to: Time.now,
                exchange_rate: Faker::Number.decimal(l_digits: 1, r_digits: 3)
            }

            @currency_exchange_rate = @current_user.account.currencies.find_by(id: @new_currency.id).exchange_rates.create!(@exchange_rate)

            @new_data = {
                valid_from: @new_valid_from,
                valid_to: @new_valid_to,
                exchange_rate: Faker::Number.decimal(l_digits: 1, r_digits: 3)
            }

            patch("/administration/account/currencies/#{@new_currency.id}/exchange_rates/#{@currency_exchange_rate.id}.json", params: {
                currency_exchange_rate: @new_data
            })

            expect_response_with_successful
            
            expect(response_body).to be_a(Hash)

            expect(response_body).to have_key("id")
            expect(response_body["id"]).to be_a(Numeric)
            expect(response_body["id"]).to eql(@currency_exchange_rate.id)

            expect(response_body).to have_key("exchange_rate")
            expect(response_body["exchange_rate"]).to be_a(String)
            expect(response_body["exchange_rate"].to_f).to eql(@new_data[:exchange_rate])

            expect(response_body).to have_key("valid_from")
            expect(response_body["valid_from"]).to be_a(String)
            expect(LC::Date2.new(Time.parse(response_body["valid_from"])).date_time.to_s).to eql(LC::Date2.new(@new_valid_from).date_time.to_s)

            expect(response_body).to have_key("valid_to")
            expect(response_body["valid_to"]).to be_a(String)
            expect(LC::Date2.new(Time.parse(response_body["valid_to"])).date_time.to_s).to eql(LC::Date2.new(@new_valid_to).date_time.to_s)

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

        it "is expected to respond with an error with the PUT verb and empty values" do 
            @current_user.account.currencies.destroy_all
            @new_valid_from = Time.now
            @new_valid_to = Time.now

            # create a valid currency
            @new_currency = @current_user.account.currencies.create!({
                name: Faker::Currency.name,
                symbol: Faker::Currency.symbol,
                country_alpha_3: Faker::Currency.code,
                user_main_id: @current_user.id,
                users_id: @current_user.id
            })
            
            # create a exchange rate that will be updated
            @exchange_rate = {
                valid_from: Time.now,
                valid_to: Time.now,
                exchange_rate: Faker::Number.decimal(l_digits: 1, r_digits: 3)
            }

            @currency_exchange_rate = @current_user.account.currencies.find_by(id: @new_currency.id).exchange_rates.create!(@exchange_rate)

            @new_data = {
                valid_from: "",
                valid_to: "",
                exchange_rate: ""
            }

            put("/administration/account/currencies/#{@new_currency.id}/exchange_rates/#{@currency_exchange_rate.id}.json", params: {
                currency_exchange_rate: @new_data
            })

            expect_response_with_error

            expect(response_body).to be_a(Hash)

            expect(response_body.keys).to contain_exactly("message", "details")
            expect(response_body["message"]).to be_a(String)
            expect(response_body["details"]).to be_an(Array)
        
        end

        it "is expected to respond with an error with the PUT verb and nil values" do 
            @current_user.account.currencies.destroy_all
            @new_valid_from = Time.now
            @new_valid_to = Time.now

            # create a valid currency
            @new_currency = @current_user.account.currencies.create!({
                name: Faker::Currency.name,
                symbol: Faker::Currency.symbol,
                country_alpha_3: Faker::Currency.code,
                user_main_id: @current_user.id,
                users_id: @current_user.id
            })
            
            # create a exchange rate that will be updated
            @exchange_rate = {
                valid_from: Time.now,
                valid_to: Time.now,
                exchange_rate: Faker::Number.decimal(l_digits: 1, r_digits: 3)
            }

            @currency_exchange_rate = @current_user.account.currencies.find_by(id: @new_currency.id).exchange_rates.create!(@exchange_rate)

            @new_data = {
                valid_from: nil,
                valid_to: nil,
                exchange_rate: nil
            }

            put("/administration/account/currencies/#{@new_currency.id}/exchange_rates/#{@currency_exchange_rate.id}.json", params: {
                currency_exchange_rate: @new_data
            })

            expect_response_with_error

            expect(response_body).to be_a(Hash)

            expect(response_body.keys).to contain_exactly("message", "details")
            expect(response_body["message"]).to be_a(String)
            expect(response_body["details"]).to be_an(Array)
        
        end

        it "is expected to respond with not found with the PUT verb and not valid id" do 
            @current_user.account.currencies.destroy_all
            @new_valid_from = Time.now
            @new_valid_to = Time.now

            # create a valid currency
            @new_currency = @current_user.account.currencies.create!({
                name: Faker::Currency.name,
                symbol: Faker::Currency.symbol,
                country_alpha_3: Faker::Currency.code,
                user_main_id: @current_user.id,
                users_id: @current_user.id
            })
            
            # create a exchange rate that will be updated
            @exchange_rate = {
                valid_from: Time.now,
                valid_to: Time.now,
                exchange_rate: Faker::Number.decimal(l_digits: 1, r_digits: 3)
            }

            @currency_exchange_rate = @current_user.account.currencies.find_by(id: @new_currency.id).exchange_rates.create!(@exchange_rate)

            @new_data = {
                valid_from: @new_valid_from,
                valid_to: @new_valid_to,
                exchange_rate: Faker::Number.decimal(l_digits: 1, r_digits: 3)
            }

            put("/administration/account/currencies/#{@current_user.account.currencies.last.id + 1}/exchange_rates/#{@currency_exchange_rate.id}.json", params: {
                currency_exchange_rate: @new_data
            })

            expect_response_with_not_found

            expect(response_body).to be_a(Hash)

            expect(response_body.keys).to contain_exactly("message")
            expect(response_body["message"]).to be_a(String)
        
        end
    end
end
