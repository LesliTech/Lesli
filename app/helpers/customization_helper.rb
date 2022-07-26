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
        # the dasherize is a workaround to keep compatibility with the 
        # older version of this helper
        logo_path = "#{lesli_instance_code}/brand/#{logo.dasherize}.svg"

        # load favicon as PNG for better compatibility between web browsers
        logo_path = "#{lesli_instance_code}/brand/#{logo.dasherize}.png" if logo == 'favicon'

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
