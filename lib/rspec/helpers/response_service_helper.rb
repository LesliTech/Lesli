=begin
    
Lesli

Copyright (c) 2023, Lesli Technologies, S. A.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see http://www.gnu.org/licenses/.

Lesli · Ruby on Rails Development Platform.

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// ·     
=end

module ServiceResponseHelpers

    # container for the response body parsed as JSON
    @@service_response = nil

    def service_response_body
        @@service_response
    end

    # test a standard successful response
    def expect_service_response_with_successful(response)
        @@service_response = nil
        expect(response.success?).to eq(true)
        expect(response.successful?).to eq(true)

        # If the response is successful, the payload could be present, but the error should be nil
        expect(response.error).to be_nil

        @@service_response = response.payload
    end

    # test a standard error response
    def expect_service_response_with_error(response)
        @@service_response = nil
        expect(response.success?).to eq(false)
        expect(response.successful?).to eq(false)

        # If the response is not successful, the error could be present, but the payload should be nil
        expect(response.payload).to be_nil

        @@service_response = response.error
    end

end
