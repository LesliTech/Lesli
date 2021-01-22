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

RSpec.shared_examples 'unauthorized standard json response' do   

    before(:all) do
        @response_body = JSON.parse(response.body)
    end

    it 'is expected to respond with a success status code (401)' do 
        expect(response).to have_http_status(:unauthorized) 
    end

    it 'is expected to respond with application/json' do 
        expect(response.content_type).to eq('application/json; charset=utf-8')
    end

    it 'is expected to respond with a successful property' do
        expect(JSON.parse(response.body)).to have_key('successful') 
    end

    it 'is expected that the successful property is false' do
        expect(JSON.parse(response.body)['successful']).to eql(false)
    end

    it 'is expected that the response will have an error property' do
        expect(JSON.parse(response.body)).to have_key('error') 
    end

    it 'is expected that error property will have a message property' do
        expect(JSON.parse(response.body)["error"]).to have_key('message') 
    end

end
