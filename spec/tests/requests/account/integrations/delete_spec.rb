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

        let(:account_integration) do
            account_integration = @current_user.account.integrations.new(name: Faker::Superhero.power)
            account_integration.user_main = @current_user
            if account_integration.save
                # register a new integration-user
                email = Faker::Internet.email

                user = @current_user.account.users.find_or_create_by(id: @current_user.id) do |user|
                    user.category = "integration"
                    user.active = true
                    user.confirm

                    user.user_roles.create({ role: ::Role.find_by(:name => "api") })

                    user.detail.first_name = account_integration_params[:name]
                    user.save!
                end
            end
            return integration = account_integration
        end

        it 'is expected to respond succesful' do
            id =  @current_user.account.integrations.last.id
            account_integration   
            created_id = @current_user.account.integrations.last.id
            delete("/administration/account/integrations/#{id}.json")

            #share examples
            expect_response_with_successful

            #validate the integration was deleted
            expect(id).to eq(created_id - 1)
            
        end

        it 'is expected to respond not found' do
            account_integration 
            id = @current_user.account.integrations.last.id  
            delete("/administration/account/integrations/#{@current_user.account.integrations.last.id + 1}.json")
            
            #share examples
            expect_response_with_not_found

            #error last integration was not deleted
            expect(id).to eq(@current_user.account.integrations.last.id)
        end

        it 'is expected to respond with successful when id is string' do
            id =  @current_user.account.integrations.last.id
            account_integration   
            created_id = @current_user.account.integrations.last.id
            delete("/administration/account/integrations/#{(@current_user.account.integrations.last.id).to_s}.json")

            #share examples
            expect_response_with_successful

            #validate the integration was deleted
            expect(id).to eq(created_id - 1)
        end
    end
end


