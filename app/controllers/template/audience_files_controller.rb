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
class Template::AudienceFilesController < ApplicationLesliController
    before_action :set_audience_file, only: [:show, :update, :destroy]

    def index
        respond_to do |format|
            format.html {}
            format.json do
                respond_with_successful(Template::AudienceFile.index(current_user, @query))
            end
        end
    end

    def show
        respond_to do |format|
            format.html {}
            format.json do
                return respond_with_not_found unless @audience_file
                return respond_with_successful(@audience_file.show(current_user, @query))
            end
        end
    end

    def new
    end

    def edit
    end

    def create
        audience_file = Template::AudienceFile.new(audience_file_params)
        if audience_file.save
            respond_with_successful(audience_file)
        else
            respond_with_error(audience_file.errors.full_messages.to_sentence)
        end
    end

    def update
        return respond_with_not_found unless @audience_file

        if @audience_file.update(audience_file_params)
            respond_with_successful(@audience_file.show(current_user, @query))
        else
            respond_with_error(@audience_file.errors.full_messages.to_sentence)
        end
    end

    def destroy
        return respond_with_not_found unless @audience_file

        if @audience_file.destroy
            respond_with_successful
        else
            respond_with_error(@audience_file.errors.full_messages.to_sentence)
        end
    end

    private

    def set_audience
        @audience = current_user.account.template.audiences.find_by(id: params[:id])
    end

    def set_audience_file
        set_audience

        return respond_with_successful unless @audience

        @audience_file = @audience.files.find_by(id: params[:id])
    end

    def audience_file_params
        params.require(:audience_file).permit(:id, :name)
    end
end