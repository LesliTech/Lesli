class Bell::EmailsController < ApplicationController
  before_action :set_bell_email, only: [:show, :edit, :update, :destroy]

  # GET /bell/emails
  def index
    @bell_emails = Bell::Email.all
  end

  # GET /bell/emails/1
  def show
  end

  # GET /bell/emails/new
  def new
    @bell_email = Bell::Email.new
  end

  # GET /bell/emails/1/edit
  def edit
  end

  # POST /bell/emails
  def create
    @bell_email = Bell::Email.new(bell_email_params)

    if @bell_email.save
      redirect_to @bell_email, notice: 'Email was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /bell/emails/1
  def update
    if @bell_email.update(bell_email_params)
      redirect_to @bell_email, notice: 'Email was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /bell/emails/1
  def destroy
    @bell_email.destroy
    redirect_to bell_emails_url, notice: 'Email was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bell_email
      @bell_email = Bell::Email.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def bell_email_params
      params.fetch(:bell_email, {})
    end
end
