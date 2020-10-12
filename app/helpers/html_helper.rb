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

module HtmlHelper

    def navigation_item(link_path)
        class_name = request.original_fullpath.include?(link_path) ? "is-active" : nil
        content_tag(:li) do
            content_tag(:a, :href => link_path, :class => class_name) do
                yield
            end
        end
    end

    def navigation_engine_item text, icon_path, path, is_active = false
        content_tag(:a, :href => path, :class => is_active ? "is-active": nil) do
            image_tag(icon_path) +
            content_tag(:span, text)
        end
    end

    def navigation_engine_babel text: "Babel", icon_path: "/assets/cloud_babel/babel-logo.svg"
        if defined? CloudBabel
            navigation_engine_item text, icon_path, cloud_babel.root_path, controller_path.include?("cloud_babel")
        end
    end

    def navigation_engine_help text: "Help", icon_path: "/assets/cloud_help/help-logo.svg"
        if defined? CloudHelp
            navigation_engine_item text, icon_path, cloud_help.root_path, controller_path.include?("cloud_help")
        end
    end

end
