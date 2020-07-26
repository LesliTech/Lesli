=begin

Lesli

Copyright (c) 2020, Lesli Technologies, S. A.

All the information provided by this website is protected by laws of Guatemala related 
to industrial property, intellectual property, copyright and relative international laws. 
Lesli Technologies, S. A. is the exclusive owner of all intellectual or industrial property
rights of the code, texts, trade mark, design, pictures and any other information.
Without the written permission of Lesli Technologies, S. A., any replication, modification,
transmission, publication is strictly forbidden.
For more information read the license file including with this software.

Lesli - Your Smart Business Assistant

Powered by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  <hello@lesli.tech>
@website  <https://lesli.tech>
@license  Propietary - all rights reserved.

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

=end

class AccountsController < ApplicationLesliController
    before_action :set_account, only: [:edit, :update, :destroy]

    # GET /accounts
    # GET /accounts.json
    # Handles a request
    # @param request [Request] the request object
    # @return [String] the resulting webpage
    def index
    end

    # GET /accounts/1
    # GET /accounts/1.json
    def show
        respond_to do |format|
            format.json {
                respond_with_successful(set_global_account)
            }
        end
    end

    # GET /accounts/new
    def new
    end

    # GET /accounts/1/edit
    def edit
    end

    # POST /accounts
    # POST /accounts.json
    def create
        current_user.account.company_name = account_params[:company_name]
        current_user.account.status = "active"
        current_user.account.save
        if current_user.account.errors.any?
            return respond_with_error(current_user.errors.full_messages.to_sentence)
        end
        respond_with_successful
    end

    # PATCH/PUT /accounts/1
    # PATCH/PUT /accounts/1.json
    def update
        return respond_with_not_found unless @account

        respond_to do |format|
            if @account.update(account_params)
                format.html { redirect_to @account, notice: 'Account was successfully updated.' }
                format.json { render :show, status: :ok, location: @account }
            else
                format.html { render :edit }
                format.json { render json: @account.errors, status: :unprocessable_entity }
            end
        end
    end

  # DELETE /accounts/1
  # DELETE /accounts/1.json
  def destroy
    return respond_with_not_found unless @account

    @account.destroy
    respond_to do |format|
      format.html { redirect_to accounts_url, notice: 'Account was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_account
        @account = current_user.account
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def account_params
        params.require(:account).permit(:company_name)
    end

end
