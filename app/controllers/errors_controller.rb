class ErrorsController < ApplicationPublicController

    def unauthorized
        respond_to do |format|
            format.html { }
            format.json { 
                render status: 401, json: {
                    successful: false,
                    error: {
                        message: "Unauthorized",
                        details: []
                    }
                }.to_json
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
            format.json { responseWithNotFound }
        end

    end

    def internal_server_error
        render status: 500, json: {
            successful: false,
            error: {
                message: 'Internal error',
                details: []
            }
        }.to_json
    end

end
