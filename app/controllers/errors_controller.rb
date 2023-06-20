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

// · IMPORTANT:
// · You have to compile rails assets to be able to test errors in development
// · You have to run rails for production with RAILS_SERVE_STATIC_FILES=true
// · Example: RAILS_SERVE_STATIC_FILES=true rails s --environment=production

=end

class ErrorsController < ApplicationController
    include Interfaces::Application::Responder

    # inspired on:
    # https://medium.com/rails-ember-beyond/error-handling-in-rails-the-modular-way-9afcddd2fe1b

    def unauthorized
        respond_to do |format|
            format.html { }
            format.json {
                respond_with_unauthorized
            }
        end
    end

    def not_found

        # check if requested url exists in the list of systems modules url path
        needs_to_login = request.original_fullpath.start_with?(
            "/crm"
        )

        # redirect to login if requested url is a "valid" system url or url path
        return redirect_to new_user_session_path(:r => request.original_fullpath) if needs_to_login === true

        # render 404 response if requested url does not exist
        respond_to do |format|
            format.html { }
            format.json { respond_with_not_found }
        end

    end

    def internal_server_error

        respond_to do |format|
            format.html { }
            format.json {

                respond_with_http(500, {
                    message: I18n.t("core.shared.messages_danger_internal_error"),
                    details: []
                })

            }
        end
    end

end
