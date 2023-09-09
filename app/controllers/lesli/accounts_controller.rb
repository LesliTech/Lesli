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

Lesli · Ruby on Rails SaaS Development Framework.

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
=end

module Lesli
    class AccountsController < ApplicationLesliController
        before_action :set_account, only: %i[show edit update destroy]

        # GET /account
        def show
            respond_to do |format|
                format.html {}
                format.json do
                    respond_with_successful(@account)
                end
            end
        end

        # GET /accounts/new
        def new
            @account = Account.new
        end

        # GET /accounts/1/edit
        def edit; end

        # POST /accounts
        def create
            @account = Account.new(account_params)

            if @account.save
                redirect_to @account, notice: "Account was successfully created."
            else
                render :new, status: :unprocessable_entity
            end
        end

        # PATCH/PUT /accounts/1
        def update
            if @account.update(account_params)
                respond_with_successful(@account)
            else
                respond_with_error(@account)
            end
        end

        # DELETE /accounts/1
        def destroy
            @account.destroy
            redirect_to accounts_url, notice: "Account was successfully destroyed.", status: :see_other
        end

        private

        # Use callbacks to share common setup or constraints between actions.
        def set_account
            #@account = current_user.account
            @account = Account.first
            return respond_with_not_found unless @account
        end

        # Only allow a list of trusted parameters through.
        def account_params
            params.require(:account).permit(
                :id,
                :company_name,
                :company_name_legal,
                :company_tagline,
                :country,
                :city,
                :postal_code,
                :address,
                :region,
                :website,
                :phone_number_1,
                :public_email,
                :github,
                :twitter,
                :youtube,
                :linkedin,
                :facebook,
                :status,
                :users_id
            )
        end
    end
end
