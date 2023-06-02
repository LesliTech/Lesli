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

Lesli · Ruby on Rails SaaS development platform.

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
=end

class Account::LogsController < ApplicationController
    before_action :set_account_log, only: [:show, :update, :destroy]

    # GET /account/logs/list.json
    def list
        respond_to do |format|
            format.html {}
            format.json do
                respond_with_successful(Account::LogServices.new(current_user, query).list)
            end
        end
    end

    # GET /account/logs
    def index
        respond_to do |format|
            format.html {}
            format.json do
                respond_with_pagination(Account::LogServices.new(current_user, query).index)
            end
        end
    end

    # GET /account/logs/:id
    def show
        respond_to do |format|
            format.html {}
            format.json do
                return respond_with_successful(@account_log.show)
            end
        end
    end

    # GET /account/logs/new
    def new
    end

    # GET /account/logs/:id/edit
    def edit
    end

    # POST /account/logs
    def create
        account_log = Account::LogServices.new(current_user, query).create(account_log_params)
        if account_log.successful?
            respond_with_successful(account_log.result)
        else
            respond_with_error(account_log.errors)
        end
    end

    # PATCH/PUT /account/logs/:id
    def update
        @account_log.update(account_log_params)

        if @account_log.successful?
            respond_with_successful(@account_log.result)
        else
            respond_with_error(@account_log.errors)
        end
    end

    # DELETE /account/logs/1
    def destroy
        return respond_with_not_found unless @account_log

        if @account_log.destroy
            respond_with_successful
        else
            respond_with_error(@account_log.errors.full_messages.to_sentence)
        end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_account_log
        @account_log = Account::LogServices.new(current_user, query).find(params[:id])
        return respond_with_not_found unless @account_log.found?
    end

    # Only allow a list of trusted parameters through.
    def account_log_params
        params.require(:account_log).permit(:id, :name)
    end
end
