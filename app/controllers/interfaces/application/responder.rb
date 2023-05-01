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

module Interfaces
    module Application
        module Responder


            # Return an standard http 200 respond
            def respond_with_successful payload=nil

                # Response for modern Lesli 3 apps
                respond_with_http(200, payload)

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
            def respond_with_pagination(records, payload=nil)

                #validate if record has data and pages
                if !records.empty? && records.total_pages > 0
                    return respond_with_http(200, {
                        :pagination => {
                            :page => records.current_page,
                            :pages => records.total_pages,
                            :total => records.total_count,
                            :results => records.length
                        },
                        :records => payload || records
                    })
                end

                #Standar pagination response with 0 results in page 1 when records is empty
                return respond_with_http(200, {
                    :pagination => {
                        #pagination always stars in page 1
                        :page =>  @query[:pagination][:page],
                        :pages =>  1,
                        :total => 0,
                        :results => 0
                    },
                    #records is empty in core
                    :records => []
                })
            end


            # JSON not found response
            def respond_with_not_found

                # Keep compatibility with Deutsche Leibrenten
                if defined? DeutscheLeibrenten
                    response_body = {
                        successful: false,
                        error: {
                            message: I18n.t("core.shared.messages_danger_not_found"),
                            details: []
                        }
                    }
                    return render(status: 404, json: response_body.to_json)
                end

                respond_with_http(404, {
                    message: I18n.t("core.shared.messages_danger_not_found")
                })
            end


            # JSON not found response
            def respond_with_unauthorized(detail = {})

                error_object = { }

                error_object[:message] = I18n.t("core.shared.view_text_unauthorized_request")
                error_object[:detail] = detail if Rails.env == "development"

                if Rails.env == "development" and !current_user.blank?
                    error_object[:role] = "( #{current_user.roles.map(&:name).join(", ")} )"
                end

                respond_to do |format|
                    format.json { render status: 401, json: error_object.to_json }
                    format.html { redirect_to "/401" } if Rails.env == "production"
                    format.html { render status: 401, json: error_object.to_json }
                    #format.xlsx { redirect_to "/401" } if Rails.env == "production"
                    #format.xlsx { render status: 401, json: error_object.to_json }
                end

            end

            # JSON failure response due users has to perform an action
            # example: respond_with_action({ :redirect => "telephone_confirmation" })
            def respond_with_action (action, message = "Action Required")
                respond_with_http(490, {
                    :message => message,
                    :action => action
                })
            end

            # JSON failure response
            def respond_with_error message = "", details = []

                # Message should be a String
                message = "" unless message.instance_of?(String)

                # TODO:
                #   check if active error and then:
                #       message = error message to sentence
                #       details = error array of messages
                #   check another types of errors and parse respond according
                respond_with_http(400, {
                    message: message,
                    details: details
                })

            end

            # Respond with an standard http message
            def respond_with_http status, payload
                return render(status: status, content_type: 'application/json', json: payload.to_json) unless payload.nil?
                return render(status: status, content_type: 'application/json', json: "")
            end

        end
    end
end
