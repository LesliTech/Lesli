=begin

Lesli

Copyright (c) 2020, Lesli Technologies, S. A.

All the information provided by this website is protected by laws of Guatemala related 
to industrial property, intellectual property, copyright and relative international laws. 
Lesli Technologies, S. A. is the exclusive owner of all intellectual or industrial property
rights of the code, texts, trade mark, design, pictures and any other information.
Without the written permission of Lesli Technologies, S. A., any replication, modification,
transmission, publication is strictly forbidden.
For more information read the license file including with this software.

Lesli - Your Smart Business Assistant

Powered by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  <hello@lesli.tech>
@website  <https://lesli.tech>
@license  Propietary - all rights reserved.

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

=end

require 'rails_helper'
require 'spec_helper'

RSpec.configure do |config|
    config.include Devise::Test::IntegrationHelpers
end

RSpec.describe 'GET /users', type: :request do

    before(:all) do
        @user = User.find_by(email: "dev@lesli.cloud")
        sign_in @user
    end
        
    it "returns all active user" do
        get "/users.json"
        expect(response).to have_http_status(:success) 
        expect(response.content_type).to eq("application/json; charset=utf-8")
        expect(JSON.parse(response.body)["successful"]).to eql(true)
    end

end
