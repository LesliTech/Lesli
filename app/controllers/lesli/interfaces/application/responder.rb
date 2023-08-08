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

Lesli · Your Smart Business Assistant. 

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// ·
=end

module Lesli
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
                    
                    respond_with_http(200, {
                        :pagination => {
                            :page => records.current_page,
                            :pages => records.total_pages,
                            :total => records.total_count,
                            :results => records.length
                        },
                        :records => payload || records
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
end
