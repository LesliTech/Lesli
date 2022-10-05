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
class Account::Currency::ExchangeRatesController < ApplicationLesliController
    before_action :set_currency, only: [:index, :create]
    before_action :set_exchange_rate, only: [:update, :destroy]

    def privileges
        {
            index: [],
            show: [],
            new: [],
            edit: [],
            destroy: [],
        }
    end

    # GET /account/currency/:account_currency/exchange_rates
    def index
        respond_to do |format|
            format.html {}
            format.json do
                respond_with_successful(Account::Currency::ExchangeRate.index(current_user, @query, @currency))
            end
        end
    end

    # GET /account/currency/exchange_rates/1
    def show
        respond_to do |format|
            format.html {}
            format.json do
                set_exchange_rate

                return respond_with_not_found unless @exchange_rate
                return respond_with_successful(@exchange_rate.show(current_user, @query))
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
        return respond_with_not_found unless @currency

        @exchange_rate = @currency.exchange_rates.create(exchange_rate_params)
        if @exchange_rate.save
            respond_with_successful(@exchange_rate.show(current_user, @query))
        else
            respond_with_error(@exchange_rate.errors.full_messages.to_sentence)
        end
    end

    # PATCH/PUT /account/currency/exchange_rates/1
    def update
        return respond_with_not_found unless @exchange_rate

        if @exchange_rate.update(exchange_rate_params)
            respond_with_successful(@exchange_rate.show(current_user, @query))
        else
            respond_with_error(@exchange_rate.errors.full_messages.to_sentence)
        end
    end

    # DELETE /account/currency/exchange_rates/1
    def destroy
        return respond_with_not_found unless @exchange_rate

        if @exchange_rate.destroy
            respond_with_successful
        else
            respond_with_error(@exchange_rate.errors.full_messages.to_sentence)
        end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_currency
        @currency = current_user.account.currencies.find_by(id: params[:currency_id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_exchange_rate
        set_currency
        return unless @currency

        @exchange_rate = @currency.exchange_rates.find_by(id: params[:id])
    end

    # Only allow a list of trusted parameters through.
    def exchange_rate_params
        params.fetch(:currency_exchange_rate, {}).permit(
            :valid_from,
            :valid_to,
            :exchange_rate
        )
    end
end
