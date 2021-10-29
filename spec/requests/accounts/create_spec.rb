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

RSpec.describe "POST:/account.json", type: :request do
    include_context 'user authentication'

    before(:all) do 

        # company_name should not be nil
        @company_name = nil

        post("/account.json", params: {
            account: {
                company_name: @company_name
            }
        })
    end

    include_examples 'error standard json response'

end

RSpec.describe "POST:/account.json", type: :request do
    include_context 'user authentication'

    before(:all) do 

        @company_name = Faker::Company.name 

        post("/account.json", params: {
            account: {
                company_name: @company_name
            }
        })
    end

    include_examples 'successful standard json response'

    it "is expected to return with account created & data nil" do 

        # data should be nil
        expect(@response_body_data).to be_nil
    end
end