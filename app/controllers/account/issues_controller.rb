=begin
Copyright (c) 2023, all rights reserved.

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
