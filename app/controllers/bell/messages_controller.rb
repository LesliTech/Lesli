class Bell::MessagesController < ApplicationController
  before_action :set_bell_message, only: [:show, :edit, :update, :destroy]

  # GET /bell/messages
  def index
    @bell_messages = Bell::Message.all
  end

  # GET /bell/messages/1
  def show
  end

  # GET /bell/messages/new
  def new
    @bell_message = Bell::Message.new
  end

  # GET /bell/messages/1/edit
  def edit
  end

  # POST /bell/messages
  def create
    @bell_message = Bell::Message.new(bell_message_params)

    if @bell_message.save
      redirect_to @bell_message, notice: 'Message was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /bell/messages/1
  def update
    if @bell_message.update(bell_message_params)
      redirect_to @bell_message, notice: 'Message was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /bell/messages/1
  def destroy
    @bell_message.destroy
    redirect_to bell_messages_url, notice: 'Message was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bell_message
      @bell_message = Bell::Message.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def bell_message_params
      params.fetch(:bell_message, {})
    end
end
