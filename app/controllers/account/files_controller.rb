=begin

Lesli

Copyright (c) 2023, Lesli Technologies, S. A.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see http://www.gnu.org/licenses/.

Lesli · Your Smart Business Assistant. 

Made with ♥ by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

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
        if @account_file.attachment_s3&.file

            # We either get the file from AWS and serve it ourselves or provide a direct AWS link with expiration time
            if @account_file.size_mb && @account_file.size_mb > Account::File.size_threshold
                redirect_to @account_file.refresh_external_url, allow_other_host: true
            else
                send_data(@account_file.attachment_s3.read, filename: @account_file.attachment_s3_identifier, disposition: disposition, stream: "true")
            end
        elsif @account_file.attachment_public&.file
            redirect_to @account_file.attachment_public_url, allow_other_host: true
        else
            send_data(@account_file.attachment.read, filename: @account_file.attachment_identifier, disposition: disposition, stream: "true")
        end
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
        account_file.user = current_user

        if account_file.save
            # IMPORTANT: This update is neccesary after the save so the file can have
            # its id on its name and be always unique
            account_file.update({})

            # Setting up file uploader to upload in background
            #Files::AwsUploadJob.perform_later(account_file)
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
        params.require(:account_file).permit(:id, :name, :attachment, :category)
    end
end
