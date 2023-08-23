module Lesli
    class AccountsController < ApplicationLesliController
        before_action :set_account, only: %i[show edit update destroy]

        # GET /accounts
        def index; end

        # GET /accounts/1
        def show; end

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
                redirect_to @account, notice: "Account was successfully updated."
            else
                render :edit, status: :unprocessable_entity
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
            # @account = Account.find(params[:id])
        end

        # Only allow a list of trusted parameters through.
        def account_params
            params.fetch(:account, {})
        end
    end
end
