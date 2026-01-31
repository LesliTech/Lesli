=begin

Lesli

Copyright (c) 2026, Lesli Technologies, S. A.

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

Lesli · Ruby on Rails SaaS Development Framework.

Made with ♥ by LesliTech
Building a better future, one line of code at a time.

@contact  hello@lesli.tech
@website  https://www.lesli.tech
@license  GPLv3 http://www.gnu.org/licenses/gpl-3.0.en.html

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 
=end

module Lesli
    module HtmlHelper

        # Prints link tags to add favicon to websites
        def lesli_favicon
            icon_path = image_url("lesli/brand/favicon.svg")
            safe_join([
                tag.link(href: icon_path, rel: "alternate icon"),
                tag.link(href: icon_path, rel: "icon", type: "image/svg+xml"),
                tag.link(href: icon_path, rel: "mask-icon", color: "#ff8a01")
            ])
        end

        # build the text for the html document title
        # this helper works only for rails pages, for vue apps the title must be handled with JS
        def lesli_website_title
            # Use instance variable if set, otherwise construct a dynamic title
            title = @application_html_title || controller_path.delete_prefix("lesli_")

            # Append action name unless it's "index"
            title += "/#{action_name}" unless action_name == "index"

            # Append company name if present
            title += " · #{Lesli.config.company.dig(:name)}"

            title
        end

        # build description using custom data from controller or engine gem description
        def lesli_website_meta_description
            # if want to get description from gem you can use:
            # Gem::Specification.find_by_name(engine_name).description
            # Gem::Specification.find_by_name(engine_name).summary
            @application_html_description || ""
        end

        # return a string with a css class to identify the body
        # example: builder engine-controller action
        def lesli_application_body_class
            [lesli_instance_code, controller_path.sub("_","-").split("/"), action_name].join(" ")
        end

        # Return a string path to load the template stylesheet
        # by default we always return the latest version of the template
        #
        # stylesheet from main App
        # lesli_stylesheet_path()               
        # /assets/application.css
        #
        # Specific stylesheet from Engine
        # lesli_stylesheet_path(:lesli, 'application') 
        # /assets/lesli/application.css
        #
        # Specific stylesheet from gem
        # lesli_stylesheet_path(:lesli_assets, 'templates/application')
        # /assets/lesli_assets/templates/application.css
        def lesli_stylesheet_path(engine = nil, stylesheet = 'application')

            # Stylesheets from specific engine
            return "#{engine}/#{stylesheet}" if engine.present?

            # Get current engine information
            engine_code = controller_path.split("/").first #lesli_engine(:code)

            # Rails main host app stylesheets
            return 'application' if engine_code == 'root'

            # Rails engines stylesheets
            "#{engine_code}/#{stylesheet}"
        end

        # print a custom icon for lesli
        def lesli_svg(name)
            content_tag("svg", width: "64px", height: "64px") do
                "<use xlink:href='##{name}'></use>".html_safe
            end
        end

        # Prints objects as JSON code
        def dd object
            content_tag(:pre) do 
                content_tag(:code) do
                    h JSON.pretty_generate(object.as_json)
                end 
            end 
        end
    end
end
