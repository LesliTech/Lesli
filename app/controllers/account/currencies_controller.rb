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
class Account::CurrenciesController < ApplicationLesliController
    before_action :set_account_currency, only: [:show, :update, :destroy]

    def privileges
        {
            index: [],
            show: [],
            new: [],
        }
    end

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
        @account_currency = current_user.account.currencies.find_by(id: params[:id])
    end

    # Only allow a list of trusted parameters through.
    def account_currency_params
        params.require(:account_currency)
        .permit(
            :name,
            :symbol,
            :country_alpha_3
        )
    end
end
