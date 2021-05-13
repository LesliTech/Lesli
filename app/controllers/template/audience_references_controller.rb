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
class Template::AudienceReferencesController < ApplicationLesliController
    before_action :set_audience_reference, only: [:show, :update, :destroy]

    def index
        respond_to do |format|
            format.html {}
            format.json do
                respond_with_successful(Template::AudienceReference.index(current_user, @query))
            end
        end
    end

    def show
        respond_to do |format|
            format.html {}
            format.json do
                return respond_with_not_found unless @audience_reference
                return respond_with_successful(@audience_reference.show(current_user, @query))
            end
        end
    end

    def new
    end

    def edit
    end

    def create
        audience_reference = Template::AudienceReference.new(audience_reference_params)
        if audience_reference.save
            respond_with_successful(audience_reference)
        else
            respond_with_error(audience_reference.errors.full_messages.to_sentence)
        end
    end

    def update
        return respond_with_not_found unless @audience_reference

        if @audience_reference.update(audience_reference_params)
            respond_with_successful(@audience_reference.show(current_user, @query))
        else
            respond_with_error(@audience_reference.errors.full_messages.to_sentence)
        end
    end

    def destroy
        return respond_with_not_found unless @audience_reference

        if @audience_reference.destroy
            respond_with_successful
        else
            respond_with_error(@audience_reference.errors.full_messages.to_sentence)
        end
    end

    def options
        options = Template::AudienceReference.options(current_user, @query)

        respond_with_successful(options)
    end

    private

    def set_audience
        @audience = current_user.account.template.audiences.find_by(id: params[:id])
    end

    def set_audience_reference
        set_audience

        return respond_with_successful unless @audience

        @audience_reference = current_user.account.template.audience_references.find_by(id: params[:id])
    end

    def audience_reference_params
        params.require(:audience_reference).permit(:id, :name)
    end
end
