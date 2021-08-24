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

    def customization_instance_logo(mode: "web", options: {alt: "Logo"})
        logo_path = "#{lesli_instance_code}/brand/app-logo-desktop.svg"
        logo_path = @account[:customization][:logo] if @account[:customization] && @account[:customization][:logo]

        if mode == "web"
            image_tag(logo_path, options)
        else
            wicked_pdf_image_tag(logo_path, options)
        end
    end

end
