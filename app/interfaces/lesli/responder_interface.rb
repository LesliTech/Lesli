=begin

Lesli

Copyright (c) 2026, Lesli Technologies, S. A.

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

        # Standard json structure for paginated data,
        # this is compatible for json, html and turbo responses
        # NOTE: LesliView::Element::Table require this structure
        #       to work properly
        # IMPORTANT: It is strictly necessary to use the pagination methods
        #            to make this work properly
        # Usage example
        # tasks = Task
        # .joins(:detail)
        # .page(query[:pagination][:page])
        # .per(query[:pagination][:perPage])
        #
        # respond_with_pagination(tasks)
        def respond_with_pagination(payload)
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

        # General response builder
        # Support for: turbo, json and html
        # Note: Turbo respond support single stream or array of streams
        # Usage:
        # respond_with(
        #     turbo: [
        #         stream_notification_success('ticket creado de forma exitosass')
        #         stream_notification_warning('ticket creado de forma exitosass')
        #     ],
        #     json: {
        #         message: "it works"
        #     },
        #     html: 'lesli/abouts/up'
        # )
        def respond_with_lesli(turbo:nil, json:nil, html:nil)
            respond_to do |format|
                format.html { render(html) }
                format.json { respond_with_json(json) }
                format.turbo_stream { render(turbo_stream: turbo) }
            end
        end

        # General error for not found resources
        # Usage:
        # def set_ticket
        #     @ticket = TicketService.new(current_user, query).find(params[:id])
        #     return respond_with_not_found unless @ticket.found?
        # end
        def respond_with_not_found message=nil
            @message = message || I18n.t("lesli.shared.message_error_resource_not_found")
            respond_to do |format|
                format.json { respond_with_json_not_found(@message) }
                format.html { render('lesli/errors/not_found', status: :not_found) }
                format.turbo_stream { render('lesli/errors/not_found', status: :not_found) }
            end
        end

        # General error for unauthorized request
        # Usage:
        #   This method is automatically triggered by the 
        #   LesliShield authentication interface, however
        #   you can use it anywhere by just invoking this method
        def respond_with_unauthorized(details = {})

            @error_object = {
                error_role: nil,
                error_detail: nil
            }

            # If dev or test, show a clear description about the auth error
            unless Rails.env.production?
                @error_object[:error_details] = details unless details.empty?
                if current_user.present?
                    @error_object[:error_role] = "(#{current_user.lesliroles.map(&:name).join(', ')})"
                end
            end

            respond_to do |format|
                format.json { respond_with_json_unauthorized(@error_object) }
                format.html { render('lesli/errors/unauthorized', status: :unauthorized) }
                format.turbo_stream { render('lesli/errors/unauthorized', status: :unauthorized) }
            end
        end


        # ~·~   ~·~   ~·~   ~·~   ~·~   ~·~   ~·~   ~·~   ~·~   ~·~   ~·~   ~·~
        # Auxiliar methods for responders
        # ~·~   ~·~   ~·~   ~·~   ~·~   ~·~   ~·~   ~·~   ~·~   ~·~   ~·~   ~·~


        # Meta-programming to define flash setter methods dynamically
        # stream_notification_success("Everything worked!")
        # stream_notification_warning("This is a warning.")
        # stream_notification_danger("Oops, there was an error.")
        # stream_notification_info("Just an informational message.")
        [:info, :success, :warning, :danger].each do |type|
            define_method(type) do |message|
                flash[type] = message
            end
            
            define_method("stream_notification_#{type}") do |message|
                flash[type] = message

                # Return the stream object so you can call: 
                # render turbo_stream: stream_notification_success("Done!")
                turbo_stream.update(
                    "application-lesli-notifications",
                    partial: "lesli/partials/application-lesli-notifications"
                )
            end
        end

        # Stream a render for a partial that includes javascript code to 
        # force redirections even when working with turbo streams
        def stream_redirection(path)
            turbo_stream.update(
                "application-lesli-notifications",
                partial: "lesli/partials/turbo/redirection",
                locals: { redirect_path: path }
            )
        end 

        # Just a simple json success response for JSON
        def respond_with_json(payload = nil)
            respond_with_http(200, payload)
        end

        # Just a simple json not found response for JSON
        def respond_with_json_not_found(message = nil)
            respond_with_http(404, {
                :status => 404,
                :error => 'Not Found',
                :message => message 
            })
        end

        # Just a simple json unauthorized response for JSON
        def respond_with_json_unauthorized(details)
            respond_with_http(401, {
                :status => 401,
                :title => 'Unauthorized',
                :message => I18n.t("core.shared.view_text_unauthorized_request"),
                :details => details
            })
        end

        # Just a simple http response for JSON
        def respond_with_http(status, payload)
            render(
                :status => status, 
                :content_type => 'application/json', 
                :json => payload.nil? ? "" : payload.to_json
            )
        end

        # General method to respond with and order for an action
        # This method exists just for compatibility poruposes,
        # a refactor is needed for this method
        def respond_with_action(action, message = "Action Required")
            respond_with_http(490, { :message => message, :action => action })
        end
    end
end
