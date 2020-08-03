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

Lesli - Your Smart Business Assistant

Powered by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  <hello@lesli.tech>
@website  <https://lesli.tech>
@license  Propietary - all rights reserved.

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
    
=end
class ProfilesController < ApplicationLesliController

    # GET /profile
    def show
    end

    def become
        #return unless current_user.email === "crm.admin@deutsche-leibrenten.de"
        #sign_in(:user, User.find(params[:id]))
        #bypass_sign_in(User.find(params[:id]))
        sign_in(:user, User.find(params[:id]))
        respond_with_successful(current_user) 
        #respond_with_successful(bypass_sign_in(User.find(params[:id]))) 
        #redirect_to root_url # or user_root_url
    end

end
