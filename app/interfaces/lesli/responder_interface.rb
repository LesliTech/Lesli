=begin

Lesli

Copyright (c) 2025, Lesli Technologies, S. A.

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

Lesli · Ruby on Rails SaaS Development Framework.

Made with ♥ by LesliTech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
=end

module Lesli
    module ResponderInterface

        # Meta-programming to define flash setter methods dynamically
        # success("Everything worked!")
        # danger("Oops, there was an error.")
        # info("Just an informational message.")
        # warning("This is a warning.")
        [:info, :success, :warning, :danger].each do |flash_type|
            define_method(flash_type) do |message|
                flash[flash_type] = message
            end
        end

        [
            :respond_with_success_notification,
            :respond_with_warning_notification,
            :respond_with_error_notification,
            :respond_with_info_notification
        ]

        # Success message response for turbo
        def respond_with_success_notification(message)
            success(message)
            render(turbo_stream: turbo_stream.update(
                "application-lesli-notifications",
                partial: "lesli/partials/application-lesli-notifications"
            ))
        end 

        # Success message response for http
        def respond_with_successful_json(payload = nil)
            respond_with_http(200, payload)
        end



        def respond_as_successful(payload)
            payload
        end

        # Usage example
        # tasks = Task
        # .joins(:detail)
        # .page(query[:pagination][:page])
        # .per(query[:pagination][:perPage])
        #
        # respond_with_pagination(tasks)
        #
        # IMPORTANT: It is strictly necessary to use the pagination methods
        #            to make this work properly
        def respond_as_pagination(payload)
            {
                pagination: {
                    page: payload.current_page,
                    pages: payload.total_pages,
                    total: payload.total_count,
                    results: payload.length
                },
                records: payload
            }
        end

        def respond_with_pagination(payload)
            respond_with_http(200, respond_as_pagination(payload))
        end

        # JSON not found response
        def respond_with_not_found message=nil

            @message = message || I18n.t("core.shared.messages_danger_not_found")
            respond_to do |format|
                format.json{ respond_with_http(404, { message: @message }) }
                format.html{ render('lesli/errors/not_found', status: :not_found) }
            end
        end

        # JSON not found response
        def respond_with_unauthorized(detail = {})

            @error_object = {
                error_role: nil,
                error_detail: nil,
                error_message: I18n.t("core.shared.view_text_unauthorized_request")
            }

            unless Rails.env.production?
                @error_object[:error_detail] = detail unless detail.empty?
                if current_user.present?
                    @error_object[:error_role] = "( #{current_user.lesliroles.map(&:name).join(', ')} )"
                end
            end

            respond_to do |format|
                format.json{ render(status: :unauthorized, json: @error_object) }
                format.html{ render('lesli/errors/unauthorized', status: :unauthorized) }

                # format.xlsx do
                #   if Rails.env.production?
                #     redirect_to "/401" # Or a specific Excel error download if applicable
                #   else
                #     # For development, you might still want a JSON response for debugging
                #     render status: :unauthorized, json: error_object.to_json
                #   end
                # end
            end
        end

        # JSON failure response due users has to perform an action
        # example: respond_with_action({ :redirect => "telephone_confirmation" })
        def respond_with_action(action, message = "Action Required")
            respond_with_http(490, { :message => message, :action => action })
        end

        # JSON failure response
        def respond_with_error(message = "", details = [])
            # Message should be a String
            message = "" unless message.instance_of?(String)

            # TODO:
            #   check if active error and then:
            #       message = error message to sentence
            #       details = error array of messages
            #   check another types of errors and parse respond according
            respond_with_http(400, { :message => message, :details => details })
        end

        # Respond with an standard http message
        def respond_with_http(status, payload)
            unless payload.nil?
                return render(:status => status, content_type: "application/json", json: payload.to_json)
            end

            render(:status => status, content_type: "application/json", json: "")
        end
    end
end
