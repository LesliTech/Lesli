=begin

Lesli

Copyright (c) 2023, Lesli Technologies, S. A.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see http://www.gnu.org/licenses/.

Lesli · Your Smart Business Assistant. 

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

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
