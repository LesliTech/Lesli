=begin

Copyright (c) 2021, all rights reserved.

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

class OtpsController < ApplicationController
    include Application::Responder
    include Application::Logger

    before_action :set_user, only: [:create]
    before_action :set_otp, only: [:update]

    # GET /otp
    def show
    end


    # POST /otps
    def create

        # check if is a valid user
        if @user.blank?
            respond_with_successful()
            return
        end

        # create a new pass
        otp = @user.access_codes.new({
            token_type: "otp"
        })

        if otp.save

            @user.logs.create({
                title: "otp_creation_successful",
                description: "user_agent: #{get_user_agent}, user_remote: #{request.remote_ip}"
            })

            UserMailer.with(user: @user, token: otp.token).otp.deliver_now

            respond_with_successful()

        else
            respond_with_error(otp.errors.full_messages.to_sentence)
        end

    end

    # PATCH/PUT /otps/1
    def update
        return respond_with_not_found unless @otp

        if @otp.update(otp_params)
            respond_with_successful(@otp.show(current_user, @query))
        else
            respond_with_error(@otp.errors.full_messages.to_sentence)
        end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_otp
        @otp = current_user.account.otps.find(class_name, params[:id])
    end

    def set_user
        @user = User.find_by(email: params[:email], active: true)

        if @user.blank?
            Account::Activity.log("core", "pass", "pass_creation_failed", "no_valid_email", {
                email: (params[:email] || "")
            })
        end
    end

    # Only allow a list of trusted parameters through.
    def otp_params
        params.require(:otp).permit(:id, :name)
    end
    
end
