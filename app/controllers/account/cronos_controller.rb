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

class Account::CronosController < ApplicationLesliController
    before_action :set_account_crono, only: [:show, :update, :destroy]

    # GET /account/cronos
    def index
        respond_to do |format|
            format.html {}
            format.json do
                respond_with_successful(Account::Crono.index(current_user, @query))
            end
        end
    end

    # GET /account/cronos/1
    def show
        respond_to do |format|
            format.html {}
            format.json do
                return respond_with_not_found unless @account_crono
                return respond_with_successful(@account_crono.show(current_user, @query))
            end
        end
    end

    # GET /account/cronos/new
    def new
    end

    # GET /account/cronos/1/edit
    def edit
    end

    # POST /account/cronos
    def create
        account_crono = current_user.account.cronos.new(account_crono_params)
        account_crono.user = current_user
        if account_crono.save
            respond_with_successful(account_crono)
        else
            respond_with_error(account_crono.errors.full_messages.to_sentence)
        end
    end

    # PATCH/PUT /account/cronos/1
    def update
        return respond_with_not_found unless @account_crono

        if @account_crono.update(account_crono_params)
            respond_with_successful(@account_crono.show(current_user, @query))
        else
            respond_with_error(@account_crono.errors.full_messages.to_sentence)
        end
    end

    # DELETE /account/cronos/1
    def destroy
        return respond_with_not_found unless @account_crono

        if @account_crono.destroy
            respond_with_successful
        else
            respond_with_error(@account_crono.errors.full_messages.to_sentence)
        end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_account_crono
        @account_crono = current_user.account.account_cronos.find(class_name, params[:id])
    end

    # Only allow a list of trusted parameters through.
    def account_crono_params
        params.require(:account_crono).permit(:id, :name, :description, :minute, :hour, :day_of_month, :month, :day_of_week)
    end
end
