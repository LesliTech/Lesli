
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
    before_action :set_account_integration, only: [:edit, :update, :destroy]

    # GET /account/integrations
    def index
        respond_to do |format|
            format.html {}
            format.json { respond_with_successful(Account::Integration.index(current_user)) }
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
        account_integration.user_main = current_user

        if account_integration.save
            # register a new integration-user
            email = Account::Integration.generate_random_email(account_integration_params[:name])

            user = current_user.account.users.find_or_create_by(email: email) do |user|
                user.category = "integration"
                user.active = true
                user.confirm

                user.user_roles.create({ role: ::Role.find_by(:name => "api") })

                user.detail.first_name = account_integration_params[:name]
                user.save!
            end

            if (user.valid?)
                account_integration.user = user
                account_integration.save # update user assignment
            end

            # register a new unique session
            current_session = user.sessions.create({
                :user_agent => LC::Request.user_agent(request.env["HTTP_USER_AGENT"]),
                :user_remote => request.remote_ip,
                :session_source => "dispatcher_standar_session",
                :last_used_at   => LC::Date.now,
                :expiration_at => params[:session][:expiration_at] || nil
            })

            respond_with_successful(current_session.session_token)
        else
            respond_with_error account_integration.errors.full_messages.to_sentence
        end
    end

    # DELETE /account/integrations/1
    def destroy
        return respond_with_not_found unless @account_integration

        if @account_integration.destroy
            respond_with_successful
        else
            respond_with_error(@account_integration.errors.full_messages.to_sentence)
        end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_account_integration
        @account_integration = current_user.account.integrations.find_by(id: params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def account_integration_params
        params.require(:account_integration).permit(:name)
    end

end
