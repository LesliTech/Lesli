class Lock::UserPrivilegesController < ApplicationController
  before_action :set_lock_user_privilege, only: [:show, :edit, :update, :destroy]

  # GET /lock/user_privileges
  def index
    @lock_user_privileges = Lock::UserPrivilege.all
  end

  # GET /lock/user_privileges/1
  def show
  end

  # GET /lock/user_privileges/new
  def new
    @lock_user_privilege = Lock::UserPrivilege.new
  end

  # GET /lock/user_privileges/1/edit
  def edit
  end

  # POST /lock/user_privileges
  def create
    @lock_user_privilege = Lock::UserPrivilege.new(lock_user_privilege_params)

    if @lock_user_privilege.save
      redirect_to @lock_user_privilege, notice: 'User privilege was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /lock/user_privileges/1
  def update
    if @lock_user_privilege.update(lock_user_privilege_params)
      redirect_to @lock_user_privilege, notice: 'User privilege was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /lock/user_privileges/1
  def destroy
    @lock_user_privilege.destroy
    redirect_to lock_user_privileges_url, notice: 'User privilege was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lock_user_privilege
      @lock_user_privilege = Lock::UserPrivilege.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def lock_user_privilege_params
      params.fetch(:lock_user_privilege, {})
    end
end
