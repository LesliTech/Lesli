=begin
Copyright (c) 2022, all rights reserved.

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
class User::DescribersController < ApplicationController
    before_action :set_user_describer, only: [:show, :update, :destroy]

    # GET /user/describers
    def index
        respond_to do |format|
            format.html {}
            format.json do
                respond_with_successful(User::Describer.index(current_user, @query))
            end
        end
    end

    # GET /user/describers/1
    def show
        respond_to do |format|
            format.html {}
            format.json do
                return respond_with_not_found unless @user_describer
                return respond_with_successful(@user_describer.show(current_user, @query))
            end
        end
    end

    # GET /user/describers/new
    def new
    end

    # GET /user/describers/1/edit
    def edit
    end

    # POST /user/describers
    def create
        user_describer = User::Describer.new(user_describer_params)
        if user_describer.save
            respond_with_successful(user_describer)
        else
            respond_with_error(user_describer.errors.full_messages.to_sentence)
        end
    end

    # PATCH/PUT /user/describers/1
    def update
        return respond_with_not_found unless @user_describer

        if @user_describer.update(user_describer_params)
            respond_with_successful(@user_describer.show(current_user, @query))
        else
            respond_with_error(@user_describer.errors.full_messages.to_sentence)
        end
    end

    # DELETE /user/describers/1
    def destroy
        return respond_with_not_found unless @user_describer

        if @user_describer.destroy
            respond_with_successful
        else
            respond_with_error(@user_describer.errors.full_messages.to_sentence)
        end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_user_describer
        @user_describer = current_user.account.user_describers.find(class_name, params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_describer_params
        params.require(:user_describer).permit(:id, :name)
    end
end
