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

RSpec.describe "PUT:/administration/account/currencies/:currency_id/exchange_rates/:id", type: :request do 
    include_context "user authentication"

    before(:all) do 
        @new_valid_from = Time.now
        @new_valid_to = Time.now

        # create a valid currency
        @new_currency = @user.account.currencies.create!({
            name: Faker::Currency.name,
            symbol: Faker::Currency.symbol,
            country_alpha_3: Faker::Currency.code,
            user_main_id: @user.id,
            users_id: @user.id
        })
        
        # create a exchange rate that will be updated
        @exchange_rate = {
            valid_from: Time.now,
            valid_to: Time.now,
            exchange_rate: Faker::Number.decimal(l_digits: 1, r_digits: 3)
        }

        @currency_exchange_rate = @user.account.currencies.find_by(id: @new_currency.id).exchange_rates.create!(@exchange_rate)

        @new_data = {
            valid_from: @new_valid_from,
            valid_to: @new_valid_to,
            exchange_rate: Faker::Number.decimal(l_digits: 1, r_digits: 3)
        }

        put("/administration/account/currencies/#{@new_currency.id}/exchange_rates/#{@currency_exchange_rate.id}.json", params: {
            currency_exchange_rate: @new_data
        })
    end

    include_examples "successful standard json response"

    it "is expected to respond with an exchange rate updated completely with the PUT verb" do 
        expect(@response_body_data).to be_a(Hash)

        expect(@response_body_data).to have_key("id")
        expect(@response_body_data["id"]).to be_a(Numeric)
        expect(@response_body_data["id"]).to eql(@currency_exchange_rate.id)

        expect(@response_body_data).to have_key("exchange_rate")
        expect(@response_body_data["exchange_rate"]).to be_a(String)
        expect(@response_body_data["exchange_rate"].to_f).to eql(@new_data[:exchange_rate])

        expect(@response_body_data).to have_key("valid_from")
        expect(@response_body_data["valid_from"]).to be_a(String)
        expect(LC::Date2.new(Time.parse(@response_body_data["valid_from"])).date_time.to_s).to eql(LC::Date2.new(@new_valid_from).date_time.to_s)

        expect(@response_body_data).to have_key("valid_to")
        expect(@response_body_data["valid_to"]).to be_a(String)
        expect(LC::Date2.new(Time.parse(@response_body_data["valid_to"])).date_time.to_s).to eql(LC::Date2.new(@new_valid_to).date_time.to_s)

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


[
    {
        :key => "valid_from",
        :value => Time.now
    },
    {
        :key => "valid_to",
        :value => Time.now
    },
    {
        :key => "exchange_rate",
        :value => Faker::Number.decimal(l_digits: 1, r_digits: 3)
    }
].each do |field_to_patch|
    RSpec.describe "PATCH:/administration/account/currencies/:currency_id/exchange_rates/:id", type: :request do 
        include_context "user authentication"
    
        before(:all) do 
            # save value
            @key_value = field_to_patch[:value]

            # create a valid currency
            @new_currency = @user.account.currencies.create!({
                name: Faker::Currency.name,
                symbol: Faker::Currency.symbol,
                country_alpha_3: Faker::Currency.code,
                user_main_id: @user.id,
                users_id: @user.id
            })
            
            # create a exchange rate that will be patched
            @exchange_rate = {
                valid_from: @new_valid_from,
                valid_to: @new_valid_to,
                exchange_rate: Faker::Number.decimal(l_digits: 1, r_digits: 3)
            }

            @currency_exchange_rate = @user.account.currencies.find_by(id: @new_currency.id).exchange_rates.create!(@exchange_rate)

            @new_data = {
                "#{field_to_patch[:key]}": @key_value 
            } 
            # make request
            patch("/administration/account/currencies/#{@new_currency.id}/exchange_rates/#{@currency_exchange_rate.id}.json", params: {
                currency_exchange_rate: @new_data
            })
        end 

        include_examples "successful standard json response"

        it "is expected to respond with an exchange rate updated by the verb PATCH" do 
            expect(@response_body_data).to be_a(Hash)
            expect(@response_body_data).to have_key(field_to_patch[:key])
            
            if field_to_patch[:key] == "exchange_rate"
                expect(@response_body_data["#{field_to_patch[:key]}"].to_f).to eql(@key_value)
            else 
                expect(LC::Date2.new(Time.parse(@response_body_data["#{field_to_patch[:key]}"])).date_time.to_s).to eql(LC::Date2.new(@key_value).date_time.to_s)
            end
        end
    end
end

RSpec.describe "PUT:/administration/account/currencies/:currency_id/exchange_rates/:id", type: :request do 
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
        put("/administration/account/currencies/#{@new_currency.id}/exchange_rates/1.json", params: {})
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

# RSpec.describe "PUT:/administration/account/currencies/:currency_id/exchange_rates/:id", type: :request do 
#     include_context "user authentication"

#     before(:all) do 
#         @new_currency = @user.account.currencies.create!({
#             name: Faker::Currency.name,
#             symbol: Faker::Currency.symbol,
#             country_alpha_3: Faker::Currency.code,
#             user_main_id: @user.id,
#             users_id: @user.id
#         })

#         @exchange_rate = {
#             valid_from: Time.now.strftime("%F %H:%M:%S"),
#             valid_to: Time.now.strftime("%F %H:%M:%S"),
#             exchange_rate: Faker::Number.decimal(l_digits: 1, r_digits: 3)
#         }
        
#         @currency_exchange_rate = @user.account.currencies.find_by(id: @new_currency.id).exchange_rates.create!(@exchange_rate)

        
#         put("/administration/account/currencies/#{@new_currency.id}/exchange_rates/#{@currency_exchange_rate.id}.json", params: {
#             currency_exchange_rate: {
#                 valid_from: "",
#                 valid_to: "",
#                 exchange_rate: ""
#             }
#         })
#     end

#     include_examples "error standard json response"

#     it "is expected to return with error when params sent are empty strings" do 
#         expect(@response_body).to be_a(Hash)

#         expect(@response_body).to have_key("error")
#         expect(@response_body["error"].keys).to contain_exactly("message", "details")
        
#         expect(@response_body["error"]["message"]).to be_a(String)
#         expect(@response_body["error"]["details"]).to be_an(Array)
#     end
# end

# RSpec.describe "PUT:/administration/account/currencies/:currency_id/exchange_rates/:id", type: :request do 
#     include_context "user authentication"

#     before(:all) do 
#         @new_currency = @user.account.currencies.create!({
#             name: Faker::Currency.name,
#             symbol: Faker::Currency.symbol,
#             country_alpha_3: Faker::Currency.code,
#             user_main_id: @user.id,
#             users_id: @user.id
#         })

#         @exchange_rate = {
#             valid_from: Time.now.strftime("%F %H:%M:%S"),
#             valid_to: Time.now.strftime("%F %H:%M:%S"),
#             exchange_rate: Faker::Number.decimal(l_digits: 1, r_digits: 3)
#         }
        
#         @currency_exchange_rate = @user.account.currencies.find_by(id: @new_currency.id).exchange_rates.create!(@exchange_rate)

        
#         put("/administration/account/currencies/#{@new_currency.id}/exchange_rates/#{@currency_exchange_rate.id}.json", params: {
#             currency_exchange_rate: {
#                 valid_from: nil,
#                 valid_to: nil,
#                 exchange_rate: nil
#             }
#         })
#     end

#     include_examples "error standard json response"

#     it "is expected to return with error when params sent are nil" do 
#         expect(@response_body).to be_a(Hash)

#         expect(@response_body).to have_key("error")
#         expect(@response_body["error"].keys).to contain_exactly("message", "details")
        
#         expect(@response_body["error"]["message"]).to be_a(String)
#         expect(@response_body["error"]["details"]).to be_an(Array)
#     end
# end
