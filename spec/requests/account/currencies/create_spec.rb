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

2.times do |num|
    RSpec.describe "POST:/administration/account/currencies", type: :request do 

        include_context "user authentication"
    
        before(:all) do
    
            @currency = {
                # :id => , ID should be assigned automatically and autoincrement
                :name => Faker::Currency.name,
                :symbol => Faker::Currency.symbol,
                :country_alpha_3 => Faker::Currency.code
            }
    
            post("/administration/account/currencies.json", params: {
                account_currency: {
                    name: @currency[:name],
                    symbol: @currency[:symbol],
                    country_alpha_3: @currency[:country_alpha_3]
                }
            })
        end
    
        include_examples "successful standard json response"
    
        it "is expected to respond with a currency created successfully" do 
            expect(@response_body_data).to be_a(Hash)
            
            expect(@response_body_data).to have_key("id")
            expect(@response_body_data["id"]).to be_a(Numeric)
            expect(@response_body_data["id"]).to eql((num + 1))
    
            expect(@response_body_data).to have_key("name")
            expect(@response_body_data["name"]).to be_a(String)
            expect(@response_body_data["name"]).to eql(@currency[:name])
           
            expect(@response_body_data).to have_key("symbol")
            expect(@response_body_data["symbol"]).to be_a(String)
            expect(@response_body_data["symbol"]).to eql(@currency[:symbol])
    
            expect(@response_body_data).to have_key("country_alpha_3")
            expect(@response_body_data["country_alpha_3"]).to be_a(String)
            expect(@response_body_data["symbol"]).to eql(@currency[:symbol])
    
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
end


# RSpec.describe "POST:/administration/account/currencies", type: :request do 

#     include_context "user authentication"

#     before(:all) do
#         post("/administration/account/currencies.json", params: {
#             account_currency: {
#                 name: "",
#                 symbol: "",
#                 country_alpha_3: "",
#             }
#         })
#     end

#     include_examples "error standard json response"

#     it "is expected to respond with error when params are empty strings" do 
#         expect(@response_body).to have_key("error")
#         expect(@response_body["error"]).to be_a(Hash)

#         expect(@response_body["error"]).to have_key("message")
#         expect(@response_body["error"]["message"]).to be_a(String)
        
#         expect(@response_body["error"]).to have_key("details")
#         expect(@response_body["error"]["details"]).to be_a(Array)
#     end
# end

# RSpec.describe "POST:/administration/account/currencies", type: :request do 

#     include_context "user authentication"

#     before(:all) do
#         post("/administration/account/currencies.json", params: {
#             account_currency: {
#                 name: nil,
#                 symbol: nil,
#                 country_alpha_3: nil,
#             }
#         })
#     end

#     include_examples "error standard json response"

#     it "is expected to respond with error when params are nil" do 
#         expect(@response_body).to have_key("error")
#         expect(@response_body["error"]).to be_a(Hash)

#         expect(@response_body["error"]).to have_key("message")
#         expect(@response_body["error"]["message"]).to be_a(String)
        
#         expect(@response_body["error"]).to have_key("details")
#         expect(@response_body["error"]["details"]).to be_a(Array)
#     end
# end
