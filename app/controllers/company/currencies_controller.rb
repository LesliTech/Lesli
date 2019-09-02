class Company::CurrenciesController < ApplicationController
  before_action :set_company_currency, only: [:show, :edit, :update, :destroy]

  # GET /company/currencies
  def index
    @company_currencies = Company::Currency.all
  end

  # GET /company/currencies/1
  def show
  end

  # GET /company/currencies/new
  def new
    @company_currency = Company::Currency.new
  end

  # GET /company/currencies/1/edit
  def edit
  end

  # POST /company/currencies
  def create
    @company_currency = Company::Currency.new(company_currency_params)

    if @company_currency.save
      redirect_to @company_currency, notice: 'Currency was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /company/currencies/1
  def update
    if @company_currency.update(company_currency_params)
      redirect_to @company_currency, notice: 'Currency was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /company/currencies/1
  def destroy
    @company_currency.destroy
    redirect_to company_currencies_url, notice: 'Currency was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_company_currency
      @company_currency = Company::Currency.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def company_currency_params
      params.fetch(:company_currency, {})
    end
end
