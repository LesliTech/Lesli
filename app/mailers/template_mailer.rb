=begin

Copyright (c) 2020, all rights reserved.

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

class TemplateMailer < ApplicationLesliMailer

    def audience_document_ready
        audience_document = params[:audience_document]
        url = params[:url]

        build_data_from_params(params, {
            url: url,
            audience_document: {
                name: audience_document.name
            },
            user: {
                full_name: audience_document.user_creator.full_name
            },
        })

        mail(
            to: audience_document.user_creator.email,
            subject: I18n.t("core.template/audience_documents.mailer_document_ready_subject")
        )
    end
end
