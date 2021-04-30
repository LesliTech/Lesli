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

// · IMPORTANT: 
// · You have to compile rails assets to be able to test errors in development
// · You have to run rails for production with RAILS_SERVE_STATIC_FILES=true
// · Example: RAILS_SERVE_STATIC_FILES=true rails s --environment=production

=end

class ErrorsController < ApplicationController
    include Application::Responder

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
                render status: 500, json: {
                    successful: false,
                    error: {
                        message: I18n.t("core.shared.messages_danger_internal_error"),
                        details: []
                    }
                }.to_json
            }
        end
    end

end
