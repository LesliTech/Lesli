class Lock::UserDetailsController < ApplicationController
  before_action :set_lock_user_detail, only: [:show, :edit, :update, :destroy]

  # GET /lock/user_details
  def index
    @lock_user_details = Lock::UserDetail.all
  end

  # GET /lock/user_details/1
  def show
  end

  # GET /lock/user_details/new
  def new
    @lock_user_detail = Lock::UserDetail.new
  end

  # GET /lock/user_details/1/edit
  def edit
  end

  # POST /lock/user_details
  def create
    @lock_user_detail = Lock::UserDetail.new(lock_user_detail_params)

    if @lock_user_detail.save
      redirect_to @lock_user_detail, notice: 'User detail was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /lock/user_details/1
  def update
    if @lock_user_detail.update(lock_user_detail_params)
      redirect_to @lock_user_detail, notice: 'User detail was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /lock/user_details/1
  def destroy
    @lock_user_detail.destroy
    redirect_to lock_user_details_url, notice: 'User detail was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lock_user_detail
      @lock_user_detail = Lock::UserDetail.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def lock_user_detail_params
      params.fetch(:lock_user_detail, {})
    end
end
