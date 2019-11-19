class LocksController < ApplicationController
  before_action :set_lock, only: [:show, :edit, :update, :destroy]

  # GET /locks
  def index
    @locks = Lock.all
  end

  # GET /locks/1
  def show
  end

  # GET /locks/new
  def new
    @lock = Lock.new
  end

  # GET /locks/1/edit
  def edit
  end

  # POST /locks
  def create
    @lock = Lock.new(lock_params)

    if @lock.save
      redirect_to @lock, notice: 'Lock was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /locks/1
  def update
    if @lock.update(lock_params)
      redirect_to @lock, notice: 'Lock was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /locks/1
  def destroy
    @lock.destroy
    redirect_to locks_url, notice: 'Lock was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_lock
      @lock = Lock.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def lock_params
      params.fetch(:lock, {})
    end
end
