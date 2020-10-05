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

module NavigationEngineHelper

    def engine_navigation text, icon_path, path
        class_name = current_page?(cloud_babel.root_path) ? "is-active" : nil
        content_tag(:li) do
            content_tag(:a, :href => path, :class => class_name) do
                image_tag(icon_path) +
                content_tag(:span, text)
            end
        end
    end

    def engine_navigation_babel text: "Translations", icon_path: "/assets/cloud_babel/babel-logo.svg" 
        if defined? CloudBabel
            engine_navigation text, icon_path, cloud_babel.root_path
        end
    end

end
