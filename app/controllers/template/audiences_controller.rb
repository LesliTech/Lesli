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
class Template::AudiencesController < ApplicationLesliController
    before_action :set_template_audience, only: [:show, :update, :destroy]

    # GET /audiences
    def index
        respond_to do |format|
            format.html {}
            format.json {
                respond_with_successful(Audience.index(current_user, @query))
            }
        end
    end

    def list
        respond_to do |format|
            format.html {}
            format.json {
                respond_with_successful(Audience.list(current_user, @query))
            }
        end
    end

    def show
        respond_to do |format|
            format.html {}
            format.json {
                respond_with_successful(CloudMailer::Audience.show(current_user, @template_audience.id))
            }
        end
    end

    def new
    end

    def edit
    end

    def create
        template_audience = current_user.account.mailer.audiences.new(template_audience_params)

        if template_audience.save
            respond_with_successful(template_audience)
        else
            respond_with_error(template_audience.errors.full_messages)
        end
    end

    def update
        return respond_with_not_found unless @template_audience

        old_attributes = @template_audience.attributes

        if @template_audience.update(template_audience_params)
            new_attributes = @template_audience.attributes

            respond_with_successful(@template_audience)
        else
            respond_with_error(@template_audience.errors.full_messages.to_sentence)
        end
    end

    def destroy
        return respond_with_not_found unless @template_audience

        if @template_audience.destroy
            respond_with_successful
        else
            respond_with_error(@template_audience.errors.full_messages.to_sentence)
        end
    end

    private

    def set_template_audience
        @template_audience = current_user.account.template_audiences.find(class_name, params[:id])
    end

    def template_audience_params
        params.require(:template_audience).permit(:name)
    end
end
