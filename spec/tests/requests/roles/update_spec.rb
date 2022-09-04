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

require "lesli_request_helper"

RSpec.describe 'PUT:/administration/roles.json', type: :request do

    include_context "request user authentication"

    it 'is expected to update a role' do

        role = FactoryBot.create(:role)
        role.object_level_permission = 1
        role.save!

        put("/administration/roles/#{role.id}.json", params: {
            role: {
                active: false
            }
        })

        # shared examples
        expect_response_with_successful        

        # custom specs
        expect(response_body["id"]).to eql(role.id)
        expect(response_body["name"]).to eql(role.name)
        expect(response_body["active"]).to eql(false)
        expect(response_body["object_level_permission"]).to eql(role.object_level_permission)
    end

    it 'is expected to fail updating a role with highest level' do

        role = FactoryBot.create(:role)
        role.object_level_permission = 2147483647
        role.save!

        put("/administration/roles/#{role.id}.json", params: {
            role: {
                name: Faker::Lorem.word
            }
        })

        # shared examples
        expect_response_with_error 

        # custom specs
        expect(response_body["message"]).to eql(I18n.t("core.roles.messages_danger_updating_role_object_level_permission_too_high"))

    end
=begin
    it 'is expected to fail updating a role with same object level permission' do

        user = FactoryBot.create(:user)
        user.user_roles.create({ role: role })

        role = FactoryBot.create(:role)
        role.object_level_permission = @current_user.roles.map(&:object_level_permission).max()
        role.save!

        

        sign_in(user)

        put("/administration/roles/#{role.id}.json", params: {
            role: {
                name: Faker::Lorem.word
            }
        })

        # shared examples
        expect_response_with_error 

        # custom specs
        expect(response_body["message"]).to eql(I18n.t("core.roles.messages_danger_updating_role_object_level_permission_too_high"))

    end
=end
end
