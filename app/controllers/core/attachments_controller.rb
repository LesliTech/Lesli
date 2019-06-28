class Core::AttachmentsController < ApplicationController
  before_action :set_core_attachment, only: [:show, :edit, :update, :destroy]

  # GET /core/attachments
  # GET /core/attachments.json
  def index
    @core_attachments = Core::Attachment.all
  end

  # GET /core/attachments/1
  # GET /core/attachments/1.json
  def show
  end

  # GET /core/attachments/new
  def new
    @core_attachment = Core::Attachment.new
  end

  # GET /core/attachments/1/edit
  def edit
  end

  # POST /core/attachments
  # POST /core/attachments.json
  def create
    @core_attachment = Core::Attachment.new(core_attachment_params)

    respond_to do |format|
      if @core_attachment.save
        format.html { redirect_to @core_attachment, notice: 'Attachment was successfully created.' }
        format.json { render :show, status: :created, location: @core_attachment }
      else
        format.html { render :new }
        format.json { render json: @core_attachment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /core/attachments/1
  # PATCH/PUT /core/attachments/1.json
  def update
    respond_to do |format|
      if @core_attachment.update(core_attachment_params)
        format.html { redirect_to @core_attachment, notice: 'Attachment was successfully updated.' }
        format.json { render :show, status: :ok, location: @core_attachment }
      else
        format.html { render :edit }
        format.json { render json: @core_attachment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /core/attachments/1
  # DELETE /core/attachments/1.json
  def destroy
    @core_attachment.destroy
    respond_to do |format|
      format.html { redirect_to core_attachments_url, notice: 'Attachment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_core_attachment
      @core_attachment = Core::Attachment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def core_attachment_params
      #params.fetch(:core_attachment, {})
      params.require(:core_attachment).permit!
    end
end
