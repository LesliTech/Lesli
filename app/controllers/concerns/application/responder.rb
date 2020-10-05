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

module Application

    module Responder
        extend ActiveSupport::Concern

        included do
        end


        def respond_with_successful data= nil
            response_body = { successful: true }
            response_body[:data] = data
            render status: 200, json: response_body.to_json
        end

        
        # JSON failure response
        def respond_with_error message = "", details = []
            render status: 200, json: {
                successful: false,
                error: {
                    message: message,
                    details: details
                }
            }.to_json
        end


        # JSON not found response
        def respond_with_not_found
            render status: 404, json: {
                successful: false,
                error: {
                    message: I18n.t("deutscheleibrenten.shared.not_found_error_message"),
                    details: []
                }
            }.to_json
        end


        # JSON not found response
        def respond_with_unauthorized(detail = {})

            error_object = {
                successful: false,
                error: {
                    message: I18n.t("deutscheleibrenten.shared.unauthorized_error_message")
                }
            }

            if Rails.env == "development"
                error_object[:error][:role] = current_user.role.detail.name
                error_object[:error][:detail] = detail
            end

            respond_to do |format|
                format.json { render status: 401, json: error_object.to_json }
                format.html { redirect_to "/401" } if Rails.env == "production"
                format.html { render status: 401, json: error_object.to_json }
            end

        end

    end

end
