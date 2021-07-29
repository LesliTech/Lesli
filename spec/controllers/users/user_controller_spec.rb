=begin
    
Copyright (c) 2020, all rights reserved.

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

require 'spec_controller_helper'

RSpec.describe UsersController, type: :controller do
    include_context 'controller user authentication'

    it "gets list of users" do 

        get :list
        expect_json_response_successful
        expect(response_body.size).to be > 0

    end

    it "gets index of users" do 

        get :index
        expect_json_response_successful
        expect(response_body.size).to be > 0

    end

    it "get the dev user" do 

        user = User.find_by(email: "dev@lesli.cloud")

        get :show, params: { id: user.id }

        expect(response_body["id"]).to eql(user.id)
        expect(response_body["email"]).to eql(user.email)
        expect(response_body["alias"]).to eql(user.alias)
        expect(response_body["active"]).to eql(user.active)
        expect(response_body["full_name"]).to eql(user.full_name)

    end

    it "get the test user" do 

        user = User.find_by(email: "test@lesli.cloud")

        get :show, params: { id: user.id }

        expect(response_body["id"]).to eql(user.id)
        expect(response_body["email"]).to eql(user.email)
        expect(response_body["alias"]).to eql(user.alias)
        expect(response_body["active"]).to eql(user.active)
        expect(response_body["full_name"]).to eql(user.full_name)

    end

    it "get the user number 5" do 

        user = User.find(5)

        get :show, params: { id: user.id }

        expect(response_body["id"]).to eql(user.id)
        expect(response_body["email"]).to eql(user.email)
        expect(response_body["alias"]).to eql(user.alias)
        expect(response_body["active"]).to eql(user.active)
        expect(response_body["full_name"]).to eql(user.full_name)

    end

end
