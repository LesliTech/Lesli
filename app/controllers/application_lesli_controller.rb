=begin

Lesli

Copyright (c) 2019, Lesli Technologies, S. A.

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

@author   LesliTech <hello@lesli.tech>
@license  Propietary - all rights reserved.
@version  0.1.0-alpha

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

=end

class ApplicationLesliController < ApplicationController
    load_and_authorize_resource
    
    before_action :authenticate_user!
    before_action :check_account
    before_action :set_account_global
    
    layout 'layouts/application'

    protected

    def authenticate_user
        if !user_signed_in?
            redirect_to root, notice: "Please Login to view that page!"
        end
    end
    
    def check_account

        return if current_user.blank?
        return if controller_name == "accounts"
        redirect_to "/account/new" if current_user.account.blank?

    end

    def set_account_global
        @account = {
            user: { 
                id: current_user.id,
                email: current_user.email,
                name: current_user.name
            },
            company: { },
            notifications: { 
                count: Courier::Bell::Notification.count(current_user)
            }
        }

        return @account if current_user.account.blank?

        # add company information (account)
        @account[:company] = {
            id: current_user.account.id,
            name: current_user.account.company_name
        }

        return @account

    end

end
