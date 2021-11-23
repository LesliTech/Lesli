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

# require "rails_helper"
# require "spec_helper"
# require "byebug"

# RSpec.describe "PATCH:/administration/account/cronos/:id", type: :request do 
#     include_context "user authentication"

#     before(:all) do 
#         @account_crono = @user.account.cronos.create!({
#             :name => Faker::Lorem.word,
#             :description => Faker::Lorem.paragraph,
#             :minute => Time.now.min,
#             :hour => Time.now.hour,
#             :day_of_month => Time.now.day,
#             :month => Time.now.month,
#             :day_of_week => Time.now.wday,
#             :users_id => @user.id
#         })

#         @new_data = {
#             :description => Faker::Lorem.paragraph,
#         }

#         patch("/administration/account/cronos/#{@account_crono.id}.json", params: {
#             account_crono: @new_data
#         })
#     end

#     include_examples "successful standard json response"

#     it "is expected to respond with a crono updated with the verb PATCH" do 
#         # PENDING, CONTROLER IS NOT WORKING CORRECTLY
#         expect(@response_body_data).to be_a(Hash)

#         expect(@response_body_data.last.keys).to contain_exactly(
#             "id",
#             "name",
#             "description",
#             "status",
#             "engine",
#             "rake",
#             "minute",
#             "hour",
#             "day_of_month",
#             "month",
#             "day_of_week",
#             "deleted_at",
#             "created_at",
#             "accounts_id",
#             "users_id"
#         )

#         # Is expected to have been updated
#         expect(@response_body_data["#{@new_data.keys[0]}"]).to be_a(String)
#         expect(@response_body_data["#{@new_data.keys[0]}"]).to eql(@new_data.values[0])
#     end
# end

# RSpec.describe "PATCH:/administration/account/cronos/:id", type: :request do
#     include_context "user authentication"

#     before(:all) do
#         @account_crono = @user.account.cronos.create!({
#             :name => Faker::Lorem.word,
#             :description => Faker::Lorem.paragraph,
#             :minute => Time.now.min,
#             :hour => Time.now.hour,
#             :day_of_month => Time.now.day,
#             :month => Time.now.month,
#             :day_of_week => Time.now.wday,
#             :users_id => @user.id
#         })

#         patch("/administration/account/cronos/#{@account_crono.id}.json", params: {
#             account_crono: {}
#         })
#     end

#     include_examples "error standard json response"

#     it "is expected to return with error when params are not sent" do 
#         expect(@response_body).to be_a(Hash)

#         expect(@response_body).to have_key("error")
#         expect(@response_body["error"].keys).to contain_exactly("message", "details")
        
#         expect(@response_body["error"]["message"]).to be_a(String)
#         expect(@response_body["error"]["details"]).to be_an(Array)
#     end
# end

    
# RSpec.describe "PATCH:/administration/account/cronos/:id", type: :request do
#     include_context "user authentication"

#     before(:all) do
#         # Look for an ID that does not exist
#         @cronos = @user.account.cronos.all.sort_by { |crono| crono.id }
#         @invalid_crono_id = @cronos.empty? ? 1 : @cronos.last["id"] + 1 

#         patch("/administration/account/cronos/#{@invalid_crono_id}.json", params: {
#             account_crono: {}
#         })
#     end

#     include_examples "not found standard json response"

#     it "is expected to return with not found" do 
#         expect(@response_body).to be_a(Hash)

#         expect(@response_body).to have_key("error")
#         expect(@response_body["error"].keys).to contain_exactly("message", "details")
        
#         expect(@response_body["error"]["message"]).to be_a(String)
#         expect(@response_body["error"]["details"]).to be_an(Array)
#     end
# end