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


RSpec.describe 'POST:/administration/template/audience_documents.json', type: :request do
    include_context 'user authentication'

    debugger
    before(:all) do
        options = Template::Document.options[:model_types]
        model_type = ""

        unless options[:model_types].blank?
            model_type = options[:model_types][0][:value]
        end

        post("/administration/template/audience_documents.json", params: {
            audience_document: {
                name: Faker::Book.title,
                model_type: model_type
            }
        })
    end

    include_examples 'successful standard json response'

    audience_document_id = @user.account.template.audience_documents.count + 1

    it 'is expected to create a new role' do
        expect(@response_body["data"]["id"]).to eql(audience_document_id)
    end
end