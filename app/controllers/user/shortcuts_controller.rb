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
class User::ShortcutsController < ApplicationLesliController
    before_action :set_user_shortcut, only: [:show, :update, :destroy]

    # GET /user/shortcuts
    def index
        respond_to do |format|
            format.html {}
            format.json do
                respond_with_successful(User::Shortcut.index(current_user, @query, params))
            end
        end
    end

    # POST /user/shortcuts
    def create
        return respond_with_error unless @current_user.shortcuts.new(user_shortcut_params).valid?

        # get the website title prefix from the lesli.yml file
        title_prefix = Rails.application.config.lesli["account"]["website"]["title_prefix"] || ""

        # remove the default prefix from the final shortcutname
        shortcut_name = (user_shortcut_params[:name]).gsub("#{ title_prefix } · ", "")

        # save shortcut if url does not exists
        user_shortcut = current_user.shortcuts
        .create_with(name: shortcut_name)
        .find_or_create_by(url: user_shortcut_params[:url])

        if user_shortcut.save
            respond_with_successful(user_shortcut)
        else
            respond_with_error(user_shortcut.errors.full_messages.to_sentence)
        end
        
    end

    # PATCH/PUT /user/shortcuts/1
    def update
        return respond_with_not_found unless @user_shortcut
        if @user_shortcut.update(user_shortcut_params)
            respond_with_successful(@user_shortcut.show(current_user, @query))
        else
            respond_with_error(@user_shortcut.errors.full_messages.to_sentence)
        end
    end

    # DELETE /user/shortcuts/1
    def destroy
        return respond_with_not_found unless @user_shortcut
        if @user_shortcut.destroy
            respond_with_successful
        else
            respond_with_error(@user_shortcut.errors.full_messages.to_sentence)
        end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_user_shortcut
        @user_shortcut = User.find_by(id: params[:user_id]).shortcuts.find_by(id: params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_shortcut_params
        params.require(:user_shortcut).permit(:id, :name, :icon, :url, :engine_code)
    end

end
