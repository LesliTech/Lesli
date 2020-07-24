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
require 'byebug'

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

RSpec.describe 'GET /users?role=owner', type: :request do

    before(:all) do
        @user = User.find_by(email: "dev@lesli.cloud")
        sign_in @user
    end
        
    it "returns only active users with owner role" do
        role = "owner"

        get "/users.json?role=#{role}"
        expect(response).to have_http_status(:success) 
        expect(response.content_type).to eq("application/json; charset=utf-8")

        #body response
        body_response = JSON.parse(response.body)

        #successful request
        expect(body_response["successful"]).to eql(true)

        #validate that only users with owner role be returned
        expect(body_response["data"].map{ |e| e["role_name"] }.uniq.join(",")).to eql(role)
    end
end

RSpec.describe 'GET /users?role={role}&type=exclude', type: :request do

    before(:all) do
        @user = User.find_by(email: "dev@lesli.cloud")
        sign_in @user
    end

    it "returns active users except first role created" do
        exclude_role = @user.account.roles.first.detail.name

        #request
        get "/users.json?role=#{exclude_role}&type=exclude"

        #response status
        expect(response).to have_http_status(:success) 
        expect(response.content_type).to eq("application/json; charset=utf-8")

        #body response
        body_response = JSON.parse(response.body)

        #successful request
        expect(body_response["successful"]).to eql(true)

        #validate that only users with especific roles be returned
        expect(body_response["data"].map{ |e| e["role_name"] }.compact.uniq).not_to match_array([exclude_role])        
    end
end

RSpec.describe 'GET /users?role={account.roles}&type=exclude', type: :request do

    before(:all) do
        @user = User.find_by(email: "dev@lesli.cloud")
        sign_in @user
    end

    it "returns no users" do
        roles = @user.account.roles.joins(:detail).select("role_details.name").map(&:name)

        #request
        get "/users.json?role=#{roles.join(",")}&type=exclude"

        #response status
        expect(response).to have_http_status(:success) 
        expect(response.content_type).to eq("application/json; charset=utf-8")

        #body response
        body_response = JSON.parse(response.body)

        #successful request
        expect(body_response["successful"]).to eql(true)

        #validate that no users be returned
        expect(body_response["data"]).to match_array([])        
    end
end