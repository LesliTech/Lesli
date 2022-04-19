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

        def respond_with_successful data= nil
            response_body = { successful: true }
            response_body[:data] = data
            render status: 200, json: response_body.to_json

            #respond_with_http(200, payload)
        end

        # Usage example
        # tasks = Task
        # .joins(:detail)
        # .page(query[:pagination][:page])
        # .per(query[:pagination][:perPage])
        # 
        # respond_with_successful_pagination(tasks)
        #
        # IMPORTANT: It is strictly necessary to use the pagination methods
        #            to make this work properly
        def respond_with_pagination records

            payload = {
                :pagination => {
                    :total_pages => records.current_page,
                    :current_page => records.current_page,
                    :count_total => records.total_count,
                    :count_results => records.length
                },
                :records => records
            }

            response_body = { successful: true }
            response_body[:payload] = payload
            render status: 200, json: response_body.to_json

=begin
            respond_with_http(200, {
                :pagination => {
                    :total_pages => records.current_page,
                    :current_page => records.current_page,
                    :count_total => records.total_count,
                    :count_results => records.length
                },
                :records => records
            })
=end
        end

        # JSON not found response
        def respond_with_not_found
            render status: 404, json: {
                successful: false,
                error: {
                    message: I18n.t("core.shared.messages_danger_not_found"),
                    details: []
                }
            }.to_json

=begin
            respond_with_http(404, { 
                message: I18n.t("core.shared.messages_danger_not_found"),
                details: []
            })
=end
        end
        
        

        

        # JSON not found response
        def respond_with_unauthorized(detail = {})
        
            error_object = {
                successful: false,
                error: {
                    message: I18n.t("core.shared.view_text_unauthorized_request")
                }
            }

            error_object[:error][:detail] = detail if Rails.env == "development"

            if Rails.env == "development" and !current_user.blank?
                error_object[:error][:role] = "( #{current_user.roles.map(&:name).join(", ")} )"
            end

            respond_to do |format|
                format.json { render status: 401, json: error_object.to_json }
                format.html { redirect_to "/401" } if Rails.env == "production"
                format.html { render status: 401, json: error_object.to_json }
                format.xlsx { redirect_to "/401" } if Rails.env == "production"
                format.xlsx { render status: 401, json: error_object.to_json }
            end

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

            # here I should use the error object and pass:
            #       message = error message to sentence
            #       details = error array of messages
=begin
            respond_with_http(400, { 
                message: message,
                details: details
            })
=end

        end

        # Respond with an standard http message
        def respond_with_http status, payload
            render(status: status, json: payload.to_json)
        end 

    end

end
