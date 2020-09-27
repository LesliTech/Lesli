class User::SessionsController < ApplicationController
  before_action :set_user_session, only: [:show, :edit, :update, :destroy]

  # GET /user/sessions
  def index
    @user_sessions = User::Session.all
  end

  # GET /user/sessions/1
  def show
  end

  # GET /user/sessions/new
  def new
    @user_session = User::Session.new
  end

  # GET /user/sessions/1/edit
  def edit
  end

  # POST /user/sessions
  def create
    @user_session = User::Session.new(user_session_params)

    if @user_session.save
      redirect_to @user_session, notice: 'Session was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /user/sessions/1
  def update
    if @user_session.update(user_session_params)
      redirect_to @user_session, notice: 'Session was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /user/sessions/1
  def destroy
    @user_session.destroy
    redirect_to user_sessions_url, notice: 'Session was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user_session
      @user_session = User::Session.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_session_params
      params.fetch(:user_session, {})
    end
end
