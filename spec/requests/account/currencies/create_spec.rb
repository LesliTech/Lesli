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

2.times do |num|
    RSpec.describe "POST:/administration/account/currencies", type: :request do 

        before(:all) do
    
            @currency = {
                # :id => , ID should be assigned automatically and autoincrement
                :name => Faker::Currency.name,
                :symbol => Faker::Currency.symbol,
                :country_alpha_3 => Faker::Currency.code
            }
     
        end

        include_context "request user authentication"
    
        it "is expected to respond with a currency created successfully" do 

            post("/administration/account/currencies.json", params: {
                account_currency: {
                    name: @currency[:name],
                    symbol: @currency[:symbol],
                    country_alpha_3: @currency[:country_alpha_3]
                }
            })

            expect_json_response_successful

            expect(response_data).to be_a(Hash)
            
            expect(response_data).to have_key("id")
            expect(response_data["id"]).to be_a(Numeric)
    
            expect(response_data).to have_key("name")
            expect(response_data["name"]).to be_a(String)
            expect(response_data["name"]).to eql(@currency[:name])
           
            expect(response_data).to have_key("symbol")
            expect(response_data["symbol"]).to be_a(String)
            expect(response_data["symbol"]).to eql(@currency[:symbol])
    
            expect(response_data).to have_key("country_alpha_3")
            expect(response_data["country_alpha_3"]).to be_a(String)
            expect(response_data["symbol"]).to eql(@currency[:symbol])
    
            expect(response_data).to have_key("user_main_id")
            expect(response_data["user_main_id"]).to be_a(Numeric)
            expect(response_data["user_main_id"]).to eql(@current_user.id)
    
            expect(response_data).to have_key("deleted_at")
            expect(response_data["deleted_at"]).to be_nil
        
            expect(response_data).to have_key("created_at")
            expect(response_data["created_at"]).to be_a(String)
            
            expect(response_data).to have_key("updated_at")
            expect(response_data["updated_at"]).to be_a(String)
    
            expect(response_data).to have_key("users_id")
            expect(response_data["users_id"]).to be_a(Numeric)
            expect(response_data["users_id"]).to eql(@current_user.id)
    
            expect(response_data).to have_key("accounts_id")
            expect(response_data["accounts_id"]).to be_a(Numeric)
            expect(response_data["accounts_id"]).to eql(@current_user.account.id)
        end

        it "is expected to respond with error when params are empty strings" do 

            post("/administration/account/currencies.json", params: {
                account_currency: {
                    name: "",
                    symbol: "",
                    country_alpha_3: "",
                }
            })

            expect_json_response_error

            expect(response_json).to have_key("error")
            expect(response_error).to be_a(Hash)

            expect(response_error).to have_key("message")
            expect(response_error["message"]).to be_a(String)
            
            expect(response_error).to have_key("details")
            expect(response_error["details"]).to be_a(Array)
        end

        it "is expected to respond with error when params are nil" do 

            post("/administration/account/currencies.json", params: {
                account_currency: {
                    name: nil,
                    symbol: nil,
                    country_alpha_3: nil,
                }
            })

            expect_json_response_error

            expect(response_json).to have_key("error")
            expect(response_error).to be_a(Hash)

            expect(response_error).to have_key("message")
            expect(response_error["message"]).to be_a(String)
            
            expect(response_error).to have_key("details")
            expect(response_error["details"]).to be_a(Array)
        end
    end
end
