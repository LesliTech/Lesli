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
class Account::Currency::ExchangeRatesController < ApplicationLesliController
    before_action :set_account_currency_exchange_rate, only: [:show, :update, :destroy]

    # GET /account/currency/exchange_rates
    def index
        respond_to do |format|
            format.html {}
            format.json do
                respond_with_successful(Account::Currency::ExchangeRate.index(current_user, @query))
            end
        end
    end

    # GET /account/currency/exchange_rates/1
    def show
        respond_to do |format|
            format.html {}
            format.json do
                return respond_with_not_found unless @account_currency_exchange_rate
                return respond_with_successful(@account_currency_exchange_rate.show(current_user, @query))
            end
        end
    end

    # GET /account/currency/exchange_rates/new
    def new
    end

    # GET /account/currency/exchange_rates/1/edit
    def edit
    end

    # POST /account/currency/exchange_rates
    def create
        account_currency_exchange_rate = Account::Currency::ExchangeRate.new(account_currency_exchange_rate_params)
        if account_currency_exchange_rate.save
            respond_with_successful(account_currency_exchange_rate)
        else
            respond_with_error(account_currency_exchange_rate.errors.full_messages.to_sentence)
        end
    end

    # PATCH/PUT /account/currency/exchange_rates/1
    def update
        return respond_with_not_found unless @account_currency_exchange_rate

        if @account_currency_exchange_rate.update(account_currency_exchange_rate_params)
            respond_with_successful(@account_currency_exchange_rate.show(current_user, @query))
        else
            respond_with_error(@account_currency_exchange_rate.errors.full_messages.to_sentence)
        end
    end

    # DELETE /account/currency/exchange_rates/1
    def destroy
        return respond_with_not_found unless @account_currency_exchange_rate

        if @account_currency_exchange_rate.destroy
            respond_with_successful
        else
            respond_with_error(@account_currency_exchange_rate.errors.full_messages.to_sentence)
        end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_account_currency_exchange_rate
        @account_currency_exchange_rate = current_user.account.account_currency_exchange_rates.find(class_name, params[:id])
    end

    # Only allow a list of trusted parameters through.
    def account_currency_exchange_rate_params
        params.require(:account_currency_exchange_rate).permit(:id, :name)
    end
end
