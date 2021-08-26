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
    def customization_instance_logo(mode: "web", options: {alt: "Logo"})
        logo_path = "#{lesli_instance_code}/brand/app-logo-desktop.svg"
        logo_path = @account[:customization][:logo] if @account[:customization] && @account[:customization][:logo]

        if mode == "pdf"
            wicked_pdf_image_tag(logo_path, options)
        else
            image_tag(logo_path, options)
        end
    end

end
