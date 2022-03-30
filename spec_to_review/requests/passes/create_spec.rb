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


require 'rails_helper'
require 'spec_helper'
require 'byebug'


RSpec.describe 'POST:/pass', type: :request do
    before(:all) do
        post("/pass.json", params: {
            email: Faker::Internet.email
        })
    end

    include_examples 'successful standard json response'

    it 'is expected to reject pass from unknown user' do
        expect(@response_body_data).to be_nil
    end
end

RSpec.describe "POST:/pass", type: :request do
    before(:all) { post "/pass.json", params: {} }

    include_examples 'successful standard json response'

    it "is expected to reject when no email is sent" do
        expect(@response_body_data).to be_nil
    end
end


# RSpec.describe 'POST:/pass', type: :request do

#     before(:all) do
#         post("/pass.json", params: {
#             email: "test@lesli.cloud"
#         })
#     end

#    include_examples 'successful standard json response'

#     it "is expected to respond with a pass created" do
#         expect(@response_body_data).to be_a(String)

#         #PENDING TO CONTINUE TESTS...
#         #THE EMAIL TEMPLATE FOR OTP DOES NOT EXIST IN THE PATH '/app/views/lesli/emails/user_mailer/pass'
#     end

# end