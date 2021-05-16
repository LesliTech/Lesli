=begin
Copyright (c) 2021, all rights reserved.

All the information provided by this platform is protected by international laws related  to
industrial property, intellectual property, copyright and relative international laws.
All intellectual or industrial property rights of the code, texts, trade mark, design,
pictures and any other information belongs to the owner of this platform.

Without the written permission of the owner, any replication, modification,
transmission, publication is strictly forbidden.

For more information read the license file including with this software.

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// ·

=end

class Account::FilesController < ApplicationLesliController
    before_action :set_account_file, only: [:show, :update, :destroy]

    # GET /account/files
    def index
        respond_to do |format|
            format.html {}
            format.json do
                respond_with_successful(Account::File.index(current_user, @query))
            end
        end
    end

    # GET /account/files/1
    def show
        return respond_with_not_found unless @account_file

        disposition = "inline"
        disposition = "attachment" if params["download"]

        # Sending file using CarrierWave
        if @account_file.attachment_s3.file
            file_name = @account_file.attachment_s3.file.filename
            file_data = @account_file.attachment_s3.read
        else
            file_name = @account_file.attachment.file.filename
            file_data = @account_file.attachment.read
        end

        file_name = @account_file.name||file_name

        send_data(file_data, filename: file_name, disposition: disposition, stream: "true")
    end

    # GET /account/files/new
    def new
    end

    # GET /account/files/1/edit
    def edit
    end

    # POST /account/files
    def create

        account_file = current_user.account.files.new(account_file_params)

        if account_file.save
            # IMPORTANT: This update is neccesary after the save so the file can have
            # its id on its name and be always unique
            account_file.update({})

            respond_with_successful(account_file)
        else
            respond_with_error(account_file.errors.full_messages.to_sentence)
        end
    end

    # PATCH/PUT /account/files/1
    def update
        return respond_with_not_found unless @account_file

        if @account_file.update(account_file_params)
            respond_with_successful(@account_file.show(current_user, @query))
        else
            respond_with_error(@account_file.errors.full_messages.to_sentence)
        end
    end

    # DELETE /account/files/1
    def destroy
        return respond_with_not_found unless @account_file

        if @account_file.destroy
            respond_with_successful
        else
            respond_with_error(@account_file.errors.full_messages.to_sentence)
        end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_account_file
        @account_file = current_user.account.files.find_by(id: params[:id])
    end

    # Only allow a list of trusted parameters through.
    def account_file_params
        params.require(:account_file).permit(:id, :name, :attachment, :file_type)
    end
end
