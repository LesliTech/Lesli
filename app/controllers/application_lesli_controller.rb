=begin

Lesli

Copyright (c) 2020, Lesli Technologies, S. A.

All the information provided by this website is protected by laws of Guatemala related 
to industrial property, intellectual property, copyright and relative international laws. 
Lesli Technologies, S. A. is the exclusive owner of all intellectual or industrial property
rights of the code, texts, trade mark, design, pictures and any other information.
Without the written permission of Lesli Technologies, S. A., any replication, modification,
transmission, publication is strictly forbidden.
For more information read the license file including with this software.

LesliCloud - Your Smart Business Assistant

Powered by https://www.lesli.tech
Building a better future, one line of code at a time.

@license  Propietary - all rights reserved.
@version  0.1.0-alpha

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

=end

class ApplicationLesliController < ApplicationController

    #load_and_authorize_resource

    before_action :authenticate_user!
    before_action :check_account
    before_action :authenticate_request
    before_action :set_global_account
    before_action :set_request_helpers
    
    layout "layouts/application"

    #rescue_from CanCan::AccessDenied do |exception|  
    #    flash[:alert] = exception.message  
    #    redirect_to "/"
    #end

    protected

    def authenticate_user
        if !user_signed_in?
            redirect_to root, notice: "Please Login to view that page!"
        end
    end

    def authenticate_request

        # if Lock module is not installed, validate only user session
        if not defined?(CloudLock)
            #return authenticate_user
        end
        
        # get user role in Lock module
        current_user_role = current_user.lock.role

        # check if role exists
        if current_user_role.blank?
            #return responseWithUnauthorized
        end

        # check if role is allowed to request the controller/action
        granted = current_user_role.privileges
        .where(:grant_object_name => params[:controller])
        .where("grant_#{params[:action]} = ?", true)
        .first

        #return responseWithUnauthorized if granted.blank?
        #return responseWithUnauthorized if not granted["grant_#{params[:action]}"] === true

    end
    
    def check_account

        return if current_user.blank?
        return if controller_name == "accounts"
        redirect_to "/account/new" if current_user.account.blank?

    end

    def set_request_helpers
        @query = {
            current_user: current_user,
            pagination: {
                perPage: (params[:perPage] ? params[:perPage].to_i : 15),
                page: (params[:page] ? params[:page].to_i : 1),
                order: "desc",
                orderColumn: "id"
            },
            filters: params[:filters] ? params[:filters] : {}
        }
        
    end

    def set_global_account 

        @account = {
            user: { 
                id: current_user.id,
                email: current_user.email,
                full_name: current_user.full_name
            },
            company: { },
            notifications: { 
                count: Courier::Bell::Notification::Web.count(current_user)
            }
        }

        return @account if current_user.account.blank?

        # add company information (account)
        @account[:company] = {
            id: current_user.account.id,
            name: current_user.account.company_name
        }

        # add custom settings
        @account[:settings] = { }
        current_user.account.settings.each do |setting|
            @account[:settings][setting[:name]] = setting[:value].to_s
        end

        @account

    end

end
