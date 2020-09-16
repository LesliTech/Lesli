=begin

Lesli

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

=end

class ApplicationApiController < ActionController::API

    before_action :authorize_request
    before_action :set_request_helpers

    @current_user = nil

    def respond_with_successful data=nil
        response_body = { successful: true }
        response_body[:data] = data
        render status: 200, json: response_body.to_json
    end
    
    # JSON failure response
    def respond_with_error message="", details=[]
        render status: 200, json: {
            successful: false,
            error: {
                message: message,
                details: details
            }
        }.to_json
    end

    # JSON not found response
    def respond_with_not_found
        render status: 404, json: {
            successful: false,
            error: {
                message: I18n.t("core.shared.not_found_error_message"),
                details: []
            }
        }.to_json
    end

    # JSON not found response
    def respond_with_unauthorized(detail = {})
        error_object = {
            successful: false,
            error: {
                message: I18n.t("core.shared.unauthorized_error_message")
            }
        }

        if Rails.env == "development"
            error_object[:error][:role] = current_user.role.detail.name
            error_object[:error][:detail] = detail
        end

        respond_to do |format|
            format.json { render status: 401, json: error_object.to_json }
            format.html { redirect_to "/401" } if Rails.env == "production"
            format.html { render status: 401, json: error_object.to_json }
        end
    end

    # Define platform version according to builder module
    def get_revision

        version = 0
        build = 0

        if defined?(DeutscheLeibrenten)
            version = DeutscheLeibrenten::VERSION
            build = DeutscheLeibrenten::BUILD
        end

        return {
            version: version,
            build: build
        }

    end

    # set query used to filter or sort data requests
    def set_request_helpers
        @query = {
            filters: params[:filters] ? params[:filters] : {},
            pagination: {
                perPage: (params[:perPage] ? params[:perPage].to_i : 15),
                page: (params[:page] ? params[:page].to_i : 1),
                order: (params[:order] ? params[:order] : "desc"),
                orderColumn: (params[:orderColumn] ? params[:orderColumn] : "id")
            }
        }
    end

    private

    def authorize_request

        # check headers for Authorization token
        if not request.headers['Authorization'].present?
            responseWithUnauthorized("Not valid authorization found")
            return
        end

        # get token sent to validate the request
        jwt_token = request.headers['Authorization'].split('Bearer ').last

        valid_jwt_token = LC::System::Jwt.decode(jwt_token)

        if not valid_jwt_token[:valid] === true
            responseWithUnauthorized("Not valid token found") 
            return
        end

        @current_user = ::User.find(valid_jwt_token[:data][0]["id"])

    end

    # Check if current_user has privileges to complete this request
    # allowed core methods:
    #   [:index, :create, :update, :destroy, :new, :show, :edit, :options, :search, :resources]
    def validate_privileges

        action = params[:action]
        action = "resources" if request.path.include?("resources")

        granted = current_user.privileges
        .where("role_privileges.grant_object = ?", params[:controller])
        .where("role_privileges.grant_#{action} = TRUE")
        .first

        # empty privileges if null privileges
        granted ||= {} 

        # if user do not has access to the requested route and can go to default route        
        if !granted["grant_#{action}"] === true && can_redirect_to_default_path
            return redirect_to current_user.role_detail[:default_path] 
        end 

        # send user to 401 page
        return respond_with_unauthorized({ controller: params[:controller], privilege: "grant_#{action}" }) if granted.blank?
        return respond_with_unauthorized({ controller: params[:controller], privilege: "grant_#{action}" }) if not granted["grant_#{action}"] === true

    end

end
