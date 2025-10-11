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
    module TurboHelper

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

        def stream_notification_success(message)
            success(message)
            turbo_stream.replace("application-lesli-notifications") do
                render("lesli/partials/application-lesli-notifications")
            end
        end

        def render_form_stream(partial_path, locals = {})

            # Detect the current engine's namespace
            engine_name = controller.class.module_parent_name.underscore

            # Ensure the correct namespace is applied (only if not already present)
            partial_path = "#{engine_name}/#{partial_path}"

            # Convert the partial path to a valid DOM ID
            partial_id = partial_path.tr("/", "-").tr("_", "-")

            # Renders the stream to update the partial
            turbo_stream.replace(partial_id) do
                render(partial_path, locals)
            end
        end
    end
end
