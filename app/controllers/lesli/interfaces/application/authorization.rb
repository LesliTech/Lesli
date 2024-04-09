module Lesli
    module Interfaces
        module Application
            module Authorization


                # Validate user authentication and session status
                def authorize_request

                    # this version Lesli requires to be mounted as root "/"
                    # engine_path = Lesli::Engine.routes.find_script_name({})
                    engine_path = nil

                    # check if the users is logged into the system
                    unless user_signed_in?

                        message = "Please Login to view that page!"

                        # check if requested url is valid
                        if (request.get? && is_navigational_format? && !request.xhr? && !request.fullpath.blank?)

                            # redirect only if the path worth it
                            if request.fullpath != "/"

                                # redirect with requested url, so user will be redirected after login
                                redirect_to("#{engine_path}/login?r=#{request.fullpath}", notice: message) and return

                            end

                        end

                        # redirect to root route
                        redirect_to("#{engine_path}/login", notice: message) and return

                    end

                    # run aditinal validations only for html requests
                    return true unless request.format.html?

                    # # get the current user session
                    # current_session = current_user.sessions.find_by(id: session[:user_session_id])

                    # # check if user has an active session
                    # if current_session.equal? nil or !current_session.active?
                    #     current_user.logs.create({ title: "system_session_logout", description: "session finished by the system"})
                    #     sign_out current_user
                    #     redirect_to "#{engine_path}/logout" and return
                    # end

                    # if !current_session.expiration_at.blank? && current_session.expiration_at < Time.current
                    #     current_user.logs.create({ title: "system_session_logout", description: "session expired by the system"})
                    #     sign_out current_user
                    #     redirect_to "#{engine_path}/logout" and return
                    # end

                    # # check password expiration date
                    # if current_user.has_expired_password?
                    #     unless controller_name == "profiles"
                    #         current_user.logs.create({ description: "redirect_due_to_expired_password" })
                    #         redirect_to "/administration/profile#force-password-reset", notice: I18n.t("core.users/sessions.messages_danger_password_expired")
                    #         return
                    #     end
                    # end

                end


                # Check if current_user has privileges to complete this request
                # allowed core methods:
                #   [:index, :create, :update, :destroy, :new, :show, :edit, :options, :search, :resources]
                def authorize_privilege

                    # check if user has access to the requested controller
                    # this search is over all the privileges for all the roles of the user
                    granted = current_user.has_privileges_for?(params[:controller], params[:action])

                    # get the path to which the user is limited to
                    limited_path = current_user.has_role_limited_to_path?

                    # to redirect to the limited path we must check:
                    #   limited_path must not to be nil or empty string ("")
                    #   limited_path must not to be equal to the current path (to avoid a loop)
                    #   request must not to be AJAX
                    #   request must be for show or index views
                    if  !limited_path.blank? and
                        !(limited_path == request.original_fullpath) and
                        !(request[:format] == "json") and
                        ["show", "index"].include?(params[:action])

                        return redirect_to(limited_path)
                    end

                    # privilege for object not found
                    if granted.blank?
                        current_user.logs.create({ title: "privilege_not_found", description: request.path })
                        return respond_with_unauthorized({ controller: params[:controller], privilege: params[:action] })
                    end

                    unless granted
                        current_user.logs.create({ title: "privilege_not_granted", description: request.path })
                        return respond_with_unauthorized({ controller: params[:controller], privilege: params[:action] })
                    end
                end
            end
        end
    end
end
