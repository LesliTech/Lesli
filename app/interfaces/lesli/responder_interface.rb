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

        # Lesli-specific response status used to tell JSON clients that they
        # must execute the action included in the response body.
        ACTION_REQUIRED_STATUS = 490

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

        # Build a response for HTML, JSON, or Turbo Stream requests.
        #
        # `html` is passed to `render`. When omitted, Rails renders the current
        # action's template. Use `redirect` for HTML redirects instead of
        # invoking `redirect_to` before calling this method. `status` applies to
        # rendered responses; redirects use `redirect_status`.
        def respond_with_lesli(
            turbo: nil,
            json: nil,
            html: nil,
            redirect: nil,
            status: :ok,
            redirect_status: :see_other
        )
            if html && redirect
                raise ArgumentError, "Use either html: or redirect:, not both"
            end

            respond_to do |format|
                format.html do
                    if redirect
                        redirect_to(redirect, status: redirect_status)
                    elsif html
                        render(html, status: status)
                    else
                        render(status: status)
                    end
                end

                format.json { respond_with_http(status, json) }
                format.turbo_stream { render(turbo_stream: turbo, status: status) }
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

        # Respond with HTTP 403 when an authenticated user does not have the
        # privileges required to perform the requested action.
        #
        # This method is used by LesliShield's authorization interface after
        # authentication has succeeded. `respond_with_unauthorized` remains
        # available as a backwards-compatible alias for existing engines.
        def respond_with_forbidden(details = {})

            @error_object = {
                error_role: nil,
                error_details: nil
            }

            # If dev or test, show a clear description about the auth error
            unless Rails.env.production?
                @error_object[:error_details] = details unless details.empty?
                if current_user.present?
                    @error_object[:error_role] = "(#{current_user.roles.map(&:name).join(', ')})"
                end
            end

            respond_to do |format|
                format.json { respond_with_json_unauthorized(@error_object) }
                format.html { render('lesli/errors/unauthorized', status: :forbidden) }
                format.turbo_stream { render('lesli/errors/unauthorized', status: :forbidden) }
            end
        end

        alias_method :respond_with_unauthorized, :respond_with_forbidden


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
            respond_with_http(:ok, payload)
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
            respond_with_http(403, {
                :status => 403,
                :title => 'Unauthorized',
                :message => I18n.t("core.shared.view_text_unauthorized_request"),
                :details => details
            })
        end

        # Just a simple http response for JSON
        def respond_with_http(status, payload = nil)
            return head(status) if payload.nil?

            render(:status => status, :json => payload)
        end

        # Tell a JSON client to execute an action before it can continue.
        # Clients using the Lesli API must handle ACTION_REQUIRED_STATUS and
        # dispatch the action included in the response body.
        def respond_with_action(action, message = "Action Required")
            respond_with_http(
                ACTION_REQUIRED_STATUS,
                { :message => message, :action => action }
            )
        end
    end
end
