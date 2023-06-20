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

module CustomizationHelper

    # @returns [String] A string representing an HTML import of the logo of the company.
    # @param mode [String] Either "web" or "pdf". This param decides wether the image_tag will be for a web view, or a pdf view
    # @param options [Hash] Any valid "image_tag" option you want to add (like width, alt, etc)
    # @descriptions Generates an image tag link so you can use on your web or pdf HTML. If the custom logo is configured, that path is
    #     returned. Otherwise, the default lesli logo stored in assets/lesli_instance/brand/ will be used
    # @example
    #     # Using this from a erb view.
    #     <div class="image">
    #         <%= customization_instance_logo(options: { alt: "#{@company.company_name}", width: "100" })%>
    #     </div>
    def customization_instance_logo(tag: false, logo: "app-logo", variant: "light", mode: "web", options: {alt: "Logo"})

        # loading logo from builder assets
        logo_path = "#{lesli_instance_code}/brand/#{logo}.svg"

        # load favicon as PNG for better compatibility between web browsers
        logo_path = "#{lesli_instance_code}/brand/#{logo}.png" if logo == 'favicon'

        # loading logo from core, only if builder engine was not installed
        logo_path = "lesli/brand/#{logo}.svg" if lesli_instance_code == "lesli"

        # custom logo from settings 
        if @account.dig(:customization, :logos, logo.to_sym)
            logo_path = @account[:customization][:logos][logo.to_sym] 
        end 

        if mode == "pdf"
            wicked_pdf_image_tag(logo_path, options)
        else
            if tag
                image_tag(logo_path, options)
            else
                image_url(logo_path, options)
            end
        end
    end

    def customization_instance_logo_tag(logo: "app-logo", variant: "light", mode: "web", options: {alt: "Logo"})
        customization_instance_logo(tag: true, logo: logo, variant: variant, mode: mode, options: options)
    end

    def customization_instance_logo_url(logo: "app-logo", variant: "light", mode: "web", options: {alt: "Logo"})
        customization_instance_logo(tag: false, logo: logo, variant: variant, mode: mode, options: options)
    end

    def default_logos
        {
            "app_icon" => "app-icon.svg",
            "app_logo" => "app-logo.svg",
            "favicon" => "favicon.png"
        }
    end
end
