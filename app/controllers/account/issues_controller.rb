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
class Account::IssuesController < ApplicationLesliController
    before_action :set_account_issue, only: [:show, :update, :destroy]

    # GET /account/issues
    def index
        respond_to do |format|
            format.html {}
            format.json do
                return respond_with_pagination(Account::IssueServices.new(current_user).index(query, params))
            end
        end
    end

    # GET /account/issues/1
    def show
        respond_to do |format|
            format.html {}
            format.json do
                return respond_with_not_found unless @account_issue.found?
                return respond_with_successful(@account_issue.show)
            end
        end
    end

    # GET /account/issues/new
    def new
    end

    # GET /account/issues/1/edit
    def edit
    end

    # POST /account/issues
    def create
        account_issue = Account::Issue.new(account_issue_params)
        account_issue.user = current_user
        account_issue.account = current_user.account

        if account_issue.save
            respond_with_successful(account_issue)
        else
            respond_with_error(account_issue.errors.full_messages.to_sentence)
        end
    end

    # PATCH/PUT /account/issues/1
    def update
         # validate that the issue exists
         return respond_with_not_found unless @account_issue.found?

         @account_issue.update(account_issue_params)
 
         if @account_issue.successful?
             respond_with_successful(@account_issue.result)
         else 
             respond_with_error(@account_issue.errors)
         end
    end

    # DELETE /account/issues/1
    def destroy
        return respond_with_not_found unless @account_issue

        if @account_issue.destroy
            respond_with_successful
        else
            respond_with_error(@account_issue.errors.full_messages.to_sentence)
        end
    end

    def options
        respond_with_successful(current_user.account.issues.options(current_user, @query))
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_account_issue
        @account_issue = Account::IssueServices.new(current_user).find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def account_issue_params
        params.require(:account_issue).permit(
            :id,
            :first_name,
            :last_name,
            :company_name,
            :email,
            :telephone,
            :message,
            :subscribed,
            :category,
            :status,
            :source,
            :reference,
            :model_type,
            :model_id,
        )
    end
end
