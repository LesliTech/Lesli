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


RSpec.describe "Unauthorized GET:/401" do
    before(:all) { get "/401.json" }

    include_examples 'unauthorized standard json response'
end


RSpec.describe "Unauthorized GET:/administration" do
    let!(:login) { "/login?r=/administration.json" }

    before(:all) { get "/administration.json" }

    it "is expected to redirect to login when user is unauthorized" do
        expect(response).to redirect_to(login)
    end
end