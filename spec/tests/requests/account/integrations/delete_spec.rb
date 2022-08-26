=begin

Copyright (c) 2022, all rights reserved.

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
require 'lesli_request_helper'


RSpec.describe "DELETE:/administration/account/integrations/:id.json", type: :request do
    describe "DELETE:/administration/account/integrations/:id.json", type: :request do
    include_context 'request user authentication'

        it 'is expected to respond succesful' do

            #puts "buscar id integrations 1 #{@current_user.account.integrations.to_json}"
            @current_user.account.integrations.create(name: Faker::Superhero.power)
            puts "buscar id integrations 2 #{@current_user.account.integrations.last}"
            
            #delete("/administration/account/integrations/new.json")

            #share examples
            #expect_response_with_successful
            #puts "respuesta #{response_body}"
        end
    end
end


