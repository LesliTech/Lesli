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
class Account::CurrenciesController < ApplicationLesliController
    before_action :set_account_currency, only: [:show, :update, :destroy]

    # GET /account/currencies
    def index
        respond_to do |format|
            format.html {}
            format.json do
                respond_with_successful(Account::Currency.index(current_user, @query))
            end
        end
    end

    # GET /account/currencies/1
    def show
        respond_to do |format|
            format.html {}
            format.json do
                return respond_with_not_found unless @account_currency
                return respond_with_successful(@account_currency.show(current_user, @query))
            end
        end
    end

    # GET /account/currencies/new
    def new
    end

    # GET /account/currencies/1/edit
    def edit
    end

    # POST /account/currencies
    def create
        account_currency = current_user.account.currencies.new(account_currency_params)
        account_currency.user_main_id = current_user.id
        account_currency.users_id = current_user.id
        if account_currency.save
            respond_with_successful(account_currency)
        else
            respond_with_error(account_currency.errors.full_messages.to_sentence)
        end
    end

    # PATCH/PUT /account/currencies/1
    def update
        return respond_with_not_found unless @account_currency

        if @account_currency.update(account_currency_params)
            respond_with_successful(@account_currency.show(current_user, @query))
        else
            respond_with_error(@account_currency.errors.full_messages.to_sentence)
        end
    end

    # DELETE /account/currencies/1
    def destroy
        return respond_with_not_found unless @account_currency

        if @account_currency.destroy
            respond_with_successful
        else
            respond_with_error(@account_currency.errors.full_messages.to_sentence)
        end
    end

    def list
        respond_to do |format|
            format.html {}
            format.json {
                respond_with_successful(Account::Currency.list(current_user, @query))
            }
        end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_account_currency
        @account_currency = current_user.account.currencies.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def account_currency_params
        params.require(:account_currency)
        .permit(
            :id,
            :name,
            :symbol,
            :country_alpha_3
        )
    end
end
