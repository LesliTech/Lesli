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
class User::WebpushesController < ApplicationLesliController
    before_action :set_user_webpush, only: [:show, :update, :destroy]

    # GET /user/webpushes
    def index
        respond_to do |format|
            format.html {}
            format.json do
                respond_with_successful(User::Webpush.index(current_user, @query))
            end
        end
    end

    # GET /user/webpushes/1
    def show
        respond_to do |format|
            format.html {}
            format.json do
                return respond_with_not_found unless @user_webpush
                return respond_with_successful(@user_webpush.show(current_user, @query))
            end
        end
    end

    # GET /user/webpushes/new
    def new
    end

    # GET /user/webpushes/1/edit
    def edit
    end

    # POST /user/webpushes
    def create
        user_webpush = User::Webpush.new(user_webpush_params)
        if user_webpush.save
            respond_with_successful(user_webpush)
        else
            respond_with_error(user_webpush.errors.full_messages.to_sentence)
        end
    end

    # PATCH/PUT /user/webpushes/1
    def update
        return respond_with_not_found unless @user_webpush

        if @user_webpush.update(user_webpush_params)
            respond_with_successful(@user_webpush.show(current_user, @query))
        else
            respond_with_error(@user_webpush.errors.full_messages.to_sentence)
        end
    end

    # DELETE /user/webpushes/1
    def destroy
        return respond_with_not_found unless @user_webpush

        if @user_webpush.destroy
            respond_with_successful
        else
            respond_with_error(@user_webpush.errors.full_messages.to_sentence)
        end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_user_webpush
        @user_webpush = current_user.account.user_webpushes.find(class_name, params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_webpush_params
        params.require(:user_webpush).permit(:id, :name)
    end
end
