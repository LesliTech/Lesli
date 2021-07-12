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
        post("/pass", params: {
            pass: {
                email: "test@lesli.cloud"
            }
        })
    end

    include_examples 'successful standard json response'

    it 'is expected to request a new pass' do
    end

end

RSpec.describe 'POST:/pass', type: :request do

    @email = "fake@email.scam"

    before(:all) do
        post("/pass", params: {
            pass: {
                email: @emailº
            }
        })
    end

    include_examples 'successful standard json response'

    it 'is expected to reject pass from unknown user' do
    end

end
