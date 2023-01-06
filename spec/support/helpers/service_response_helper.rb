=begin

Copyright (c) 2023, all rights reserved.

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

module ServiceResponseHelpers

    # container for the response body parsed as JSON
    @@response = nil

    def response_body
        @@response
    end

    # test a standard successful response
    def expect_response_with_successful(response)
        @@response = nil
        expect(response.success?).to eq(true)
        expect(response.successful?).to eq(true)
        expect(response.payload).not_to be_nil
        expect(response.error).to be_nil

        @@response = response.payload
    end

    # test a standard error response
    def expect_response_with_error(response)
        @@response = nil
        expect(response.success?).to eq(false)
        expect(response.successful?).to eq(false)
        expect(response.payload).to be_nil
        expect(response.error).not_to be_nil

        @@response = response.error
    end

end
