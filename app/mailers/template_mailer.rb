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
