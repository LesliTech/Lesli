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
class User::AccessCodesController < ApplicationLesliController
    before_action :set_user_access_code, only: [:show, :update, :destroy]

    # GET /user/access_codes
    def index
        respond_to do |format|
            format.html {}
            format.json do
                respond_with_successful(User::AccessCode.index(current_user, @query))
            end
        end
    end

    # GET /user/access_codes/1
    def show
        respond_to do |format|
            format.html {}
            format.json do
                return respond_with_not_found unless @user_access_code
                return respond_with_successful(@user_access_code.show(current_user, @query))
            end
        end
    end

    # GET /user/access_codes/new
    def new
    end

    # GET /user/access_codes/1/edit
    def edit
    end

    # POST /user/access_codes
    def create
        user_access_code = User::AccessCode.new(user_access_code_params)
        if user_access_code.save
            respond_with_successful(user_access_code)
        else
            respond_with_error(user_access_code.errors.full_messages.to_sentence)
        end
    end

    # PATCH/PUT /user/access_codes/1
    def update
        return respond_with_not_found unless @user_access_code

        if @user_access_code.update(user_access_code_params)
            respond_with_successful(@user_access_code.show(current_user, @query))
        else
            respond_with_error(@user_access_code.errors.full_messages.to_sentence)
        end
    end

    # DELETE /user/access_codes/1
    def destroy
        return respond_with_not_found unless @user_access_code

        if @user_access_code.destroy
            respond_with_successful
        else
            respond_with_error(@user_access_code.errors.full_messages.to_sentence)
        end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_user_access_code
        @user_access_code = current_user.account.user_access_codes.find(class_name, params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_access_code_params
        params.require(:user_access_code).permit(:id, :name)
    end
end
