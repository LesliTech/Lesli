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

module ResponseHelpers

    # container for the response body parsed as JSON
    @@response_json = nil

    # return the body of a request response parsed as JSON
    def response_json
        # support empty responses from lesli 3 responder
        _response_ = response.body.blank? ? "{}" : response.body
        @@response_json = JSON.parse(_response_) if @@response_json.blank?
        @@response_json
    end

    # test a standard successful response for lesli 3
    def expect_response_with_successful
        @@response_json = nil
        expect(response).to have_http_status(:success)
        expect(response.content_type).to eq("application/json; charset=utf-8")
        response_json()
    end

    # test a standard successful response for lesli 3
    def expect_response_with_pagination
        @@response_json = nil

        expect(response).to have_http_status(:success)
        expect(response.content_type).to eq("application/json; charset=utf-8")

        expect(response_json).to have_key("pagination")
        expect(response_json["pagination"]).to be_an_instance_of(Hash)
        expect(response_json["pagination"]).to have_key("pages")
        expect(response_json["pagination"]).to have_key("page")
        expect(response_json["pagination"]).to have_key("total")
        expect(response_json["pagination"]).to have_key("results")
        expect(response_json["pagination"]["pages"]).to be_an_instance_of(Integer)

        expect(response_json).to have_key("records")
        expect(response_json["records"]).to be_an_instance_of(Array)

        expect(response_json["pagination"]["results"]).to eql(response_json["records"].size)

        response_json()
    end

    # test a standard error response for lesli 3
    def expect_response_with_error
        @@response_json = nil
        expect(response).to have_http_status(:bad_request)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(response_json).to be_an_instance_of(Hash)
        expect(response_json).to have_key('message')
        expect(response_json).to have_key('details')
    end

    # test a standard not found response for lesli 3
    def expect_response_with_not_found
        @@response_json = nil
        expect(response).to have_http_status(:not_found)
        expect(response.content_type).to eq("application/json; charset=utf-8")
    end

    # test a standard unauthorized response for lesli 3
    def expect_response_with_unauthorized
        @@response_json = nil
        expect(response).to have_http_status(:unauthorized)
        expect(response.content_type).to eq("application/json; charset=utf-8")
        expect(response_json).to have_key('message')
    end

    # function to expect a response with the given params
    # example
    # shared_expects validates the response body with the given arguments
    # params
    #   - response_body: the response to validate
    #   - resquest_body: the payload that was sent to the server
    #   - expected_response: the expected response is an array of hashes that contain the expected values
    # example
    #
    # shared_expects(response_body, project, [
    #     { key: "hexid", expected_type: "string" },
    #     { key: "payment_period", expected_type: "string", expected_value: "no_information" },
    #     { key: "payment_amount", expected_type: "string", expected_value: "0.0" },
    #     { key: "payment_amount", expected_type: "string", expected_value: "0.0", or_be_nil: true },
    #     { key: "quality", expected_type: "integer" },
    #     { key: "main_file_id", expected_type: "nil" }
    # ])
    def shared_expects(response_body, request_body, expected_attrs)
        expect(response_body).to be_an(Object)

        # iterate over the expected attributes
        expected_attrs.each do |expected_attr|

            # verify if response has specific attribute
            expect(response_body).to have_key(expected_attr[:key])

            # verify if response attribute has the expected value type
            case expected_attr[:expected_type]
                when "boolean", "bool"
                    expect(response_body[expected_attr[:key]]).to be_in([true, false])
                when "string", "str"
                    expect(response_body[expected_attr[:key]]).to be_a(String)
                when "integer", "int"
                    expect(response_body[expected_attr[:key]]).to be_a(Integer)
                when "float"
                    expect(response_body[expected_attr[:key]]).to be_a(Float)
                when "nil"
                    expect(response_body[expected_attr[:key]]).to be_nil
                when "array"
                    expect(response_body[expected_attr[:key]]).to be_an_instance_of(Array)
                when "hash"
                    expect(response_body[expected_attr[:key]]).to be_an_instance_of(Hash)
                when "object"
                    expect(response_body[expected_attr[:key]]).to be_an(Object)
            end

            # verify if response value is equal to the expected value
            if expected_attr[:expected_value].present?
                expect(response_body[expected_attr[:key]]).to eq(expected_attr[:expected_value]) unless expected_attr[:or_be_nil]
                expect(response_body[expected_attr[:key]]).to eq(expected_attr[:expected_value]).or be_nil
            end

            # verify if response value is equal to request value
            if request_body[expected_attr[:key]].present?
                expect(response_body[expected_attr[:key]]).to eq(request_body[expected_attr[:key]])
            end
        end
    end

    # shortcut for response_json
    def response_body
        response_json
    end

    # test a response that contains a xlsx file
    def expect_response_with_xlsx
        @@response_json = nil
        expect(response).to have_http_status(:success)

        # In the case of Excel files the response has a specific content type
        # And it's up the version, so we have two posibilities
        expect(response.content_type).to be_in([
            "application/vnd.ms-excel",
            "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet" # For Excel2007 and above
        ])
    end

    # test a response that contains a PDF file
    def expect_response_with_pdf
        @@response_json = nil
        expect(response).to have_http_status(:success)
        expect(response.content_type).to eq("application/pdf")
    end



    # Compatibility with Lesli 2
    # -·-     -·-     -·-     -·-     -·-     -·-     -·-     -·-     -·-     -·-


    def response_data
        response_json["data"] || response_json["payload"]
    end

    def response_error
        response_json["error"]
    end

    def expect_json_response_successful
        @@response_json = nil
        expect(response).to have_http_status(:success)
        expect(response.content_type).to eq("application/json; charset=utf-8")
        expect(response_json).to have_key('successful')
        expect(response_json["successful"]).to eql(true)
        expect(response_json).to have_key("data").or have_key("payload")
    end

    def expect_json_response_error
        @@response_json = nil
        expect(response).to have_http_status(:success)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(response_json).to have_key('successful')
        expect(response_json['successful']).to eql(false)
        expect(response_json).to have_key('error')
        expect(response_json["error"]).to have_key('message')
    end

    def expect_json_response_not_found
        @@response_json = nil
        expect(response).to have_http_status(:not_found)
        expect(response.content_type).to eq("application/json; charset=utf-8")
        expect(response_json).to have_key('successful')
        expect(response_json['successful']).to eql(false)
        expect(response_json).to have_key('error')
        expect(response_json["error"]).to have_key('message')
    end

    def expect_json_response_unauthorized
        @@response_json = nil
        expect(response).to have_http_status(:unauthorized)
        expect(response.content_type).to eq("application/json; charset=utf-8")
        expect(response_json).to have_key('successful')
        expect(response_json['successful']).to eql(false)
        expect(response_json).to have_key('error')
        expect(response_json["error"]).to have_key('message')
    end

end
