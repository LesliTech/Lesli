class Core::AccountsController < ApplicationController
  before_action :set_core_account, only: [:show, :edit, :update, :destroy]

  # GET /core/accounts
  def index
    @core_accounts = Core::Account.all
  end

  # GET /core/accounts/1
  def show
  end

  # GET /core/accounts/new
  def new
    @core_account = Core::Account.new
  end

  # GET /core/accounts/1/edit
  def edit
  end

  # POST /core/accounts
  def create
    @core_account = Core::Account.new(core_account_params)

    if @core_account.save
      redirect_to @core_account, notice: 'Account was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /core/accounts/1
  def update
    if @core_account.update(core_account_params)
      redirect_to @core_account, notice: 'Account was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /core/accounts/1
  def destroy
    @core_account.destroy
    redirect_to core_accounts_url, notice: 'Account was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_core_account
      @core_account = Core::Account.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def core_account_params
      params.fetch(:core_account, {})
    end
end
