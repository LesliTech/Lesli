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

module Lesli
    module GeneralHelper
        # build a url path to change locales
        def language_url(locale)
            "/lesli/language?locale=#{locale}"
        end

        # return flag code according to locale code
        def language_flag(locale)
            locale = "gb" if locale.to_s == "en"
            locale
        end

        # return the name of the language
        def language_name(locale)
            Lesli.config.locales.dig(locale) || "undefined"
        end

        # return a string with a css class to identify the body
        # example: builder engine-controller action
        def application_body_class
            [lesli_instance_code, controller_path.sub("_","-").split("/"), action_name].join(" ")
        end

        # build the text for the html document title
        # this helper works only for rails pages, for vue apps the title must be handled with JS
        def website_title
            # Use instance variable if set, otherwise construct a dynamic title
            title = @application_html_title || controller_path.delete_prefix("lesli_")

            # Append action name unless it's "index"
            title += "/#{action_name}" unless action_name == "index"

            # Append company name if present
            title += " · #{Lesli.config.company.dig(:name)}"

            title
        end

        # build description using custom data from controller or engine gem description
        def website_meta_description
            # if want to get description from gem you can use:
            # Gem::Specification.find_by_name(engine_name).description
            # Gem::Specification.find_by_name(engine_name).summary
            @application_html_description || ""
        end

        def dd object
            content_tag(:pre) do 
                content_tag(:code) do
                    h JSON.pretty_generate(object.as_json)
                end 
            end 
        end
    end
end
