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
class Account::IssuesController < ApplicationController
    before_action :set_account_issue, only: [:show, :update, :destroy]

    # GET /account/issues
    def index
        respond_to do |format|
            format.html {}
            format.json do
                respond_with_successful(Account::Issue.index(current_user, @query))
            end
        end
    end

    # GET /account/issues/1
    def show
        respond_to do |format|
            format.html {}
            format.json do
                return respond_with_not_found unless @account_issue
                return respond_with_successful(@account_issue.show(current_user, @query))
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
        if account_issue.save
            respond_with_successful(account_issue)
        else
            respond_with_error(account_issue.errors.full_messages.to_sentence)
        end
    end

    # PATCH/PUT /account/issues/1
    def update
        return respond_with_not_found unless @account_issue

        if @account_issue.update(account_issue_params)
            respond_with_successful(@account_issue.show(current_user, @query))
        else
            respond_with_error(@account_issue.errors.full_messages.to_sentence)
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

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_account_issue
        @account_issue = current_user.account.account_issues.find_by_id(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def account_issue_params
        params.fetch(:account_issue, {}).permit(:id, :name)
    end
end
