=begin

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

class Account::IntegrationsController < ApplicationLesliController
    before_action :set_account_integration, only: [:show, :edit, :update, :destroy]

    # GET /account/integrations
    def index
        respond_to do |format|
            format.html {}
            format.json { respond_with_successful(Account::Integration.index(current_user)) }
        end
    end

    # GET /account/integrations/1
    def show
        respond_to do |format|
            format.html {}
            format.json { respond_with_successful(Account::Integration.show(current_user, params)) }
        end
    end

    # GET /account/integrations/new
    def new
    end

    # GET /account/integrations/1/edit
    def edit
    end

    # POST /account/integrations
    def create
        account_integration = current_user.account.integrations.new(account_integration_params)

        user_integration_email = account_integration_params[:name]
        .downcase                           # string to lowercase
        .gsub(/[^0-9A-Za-z\s\-\_]/, "")     # remove special characters from string
        .gsub(/\s+/, "-")                   # replace spaces or spaces with single dash
        .concat("-", SecureRandom.hex(4), "@integrations")

        # register a new integration-user
        user = current_user.account.users.find_or_create_by(email: user_integration_email) do |user|
            user.category = "integration"
            user.active = true
            user.confirm

            user.user_roles.create({ role: ::Role.find_by(:name => "api") })

            user.detail.first_name = account_integration_params[:name]
            user.save!
        end

        account_integration.user_main = current_user
        account_integration.user = user 

        if account_integration.save

            # register a new unique session
            current_session = user.sessions.create({
                :user_agent => LC::Request.user_agent(request.env["HTTP_USER_AGENT"]),
                :user_remote => request.remote_ip,
                :session_source => "dispatcher_standar_session",
                :last_used_at   => LC::Date.now
            })

            respond_with_successful account_integration

        else
            respond_with_error account_integration.errors.full_messages.to_sentence
        end
    end

    # PATCH/PUT /account/integrations/1
    def update
        if @account_integration.update(account_integration_params)
            redirect_to @account_integration, notice: 'Integration was successfully updated.'
        else
            render :edit
        end
    end

    # DELETE /account/integrations/1
    def destroy
        @account_integration.destroy
        redirect_to account_integrations_url, notice: 'Integration was successfully destroyed.'
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_account_integration
        #current_user.account.integrations
        #@account_integration = Account::Integration.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def account_integration_params
        params.require(:account_integration).permit(:id, :name)
    end

end
