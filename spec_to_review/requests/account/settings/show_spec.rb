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

# RSpec.describe "GET:/administration/account/settings/:id", type: :request do 

#     include_context "user authentication"

#     before(:all) do 
#         @name = "date_format"
#         @value = "%d.%m.%Y"

#         @new_setting = @user.account.settings.create({
#             name: @name,
#             value: @value
#         })
            
#         get "/administration/account/settings/#{@new_setting.id}.json"
#     end

#     include_examples "successful standard json response"

#     it "is expected to respond with a setting record" do 

#         expect(@response_body_data).to be_a(Hash)

#         expect(@response_body_data).to have_key("id")
#         expect(@response_body_data["id"]).to be_a(Numeric)
#         expect(@response_body_data["id"]).to eql(@new_setting.id)
        
#         expect(@response_body_data).to have_key("name")
#         expect(@response_body_data["name"]).to be_a(String)
#         expect(@response_body_data["name"]).to eql(@new_setting.name)

#         expect(@response_body_data).to have_key("value")
#         expect(@response_body_data["value"]).to be_a(String)
#         expect(@response_body_data["value"]).to eql(@new_setting.value)

#         expect(@response_body_data).to have_key("created_at")
#         expect(@response_body_data["created_at"]).to be_a(String)

#         expect(@response_body_data).to have_key("updated_at")
#         expect(@response_body_data["updated_at"]).to be_a(String)

#         expect(@response_body_data).to have_key("accounts_id")
#         expect(@response_body_data["accounts_id"]).to be_a(Numeric)
#         expect(@response_body_data["accounts_id"]).to eql(@user.account.id)
#     end

# end  