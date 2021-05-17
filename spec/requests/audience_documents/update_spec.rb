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


RSpec.describe 'PUT:/administration/template/audience_documents.json', type: :request do
    include_context 'user authentication'

    before(:all) do
        @audience_document = @user.account.template.audience_documents.first
        @audience_document_name = Faker::Book.title
        put("/administration/template/audience_documents/#{@audience_document.id}.json", params: {
            audience_document: {
                name: @audience_document_name
            }
        })
    end

    include_examples 'successful standard json response'

    it 'is expected to update a audience document' do
        expect(@response_body["data"]["id"]).to eql(@audience_document.id)
        expect(@response_body["data"]["name"]).to eql(@audience_document_name)
        expect(@response_body["data"]["model_type"]).to eql(@audience_document.model_type)
    end
end