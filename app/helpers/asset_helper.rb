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

module AssetHelper

    def application_stylesheet_theme_path()

        theme = "themes/blank"

        unless Rails.application.config.lesli_settings["configuration"]["theme"].blank?
            theme = [
                "themes", 
                Rails.application.config.lesli_settings["configuration"]["theme"],
                Rails.application.config.lesli_settings["configuration"]["theme"]
            ].join("/")
        end

        theme

    end

    def application_stylesheet_path

        path_segments = controller_path.split("/")
        cloud_module = path_segments.shift

        if ["cloud_text", "cloud_house", "cloud_driver", "cloud_focus"].include?(cloud_module)
            return [cloud_module, [cloud_module, "app"].join("_")].join("/")
        end

        controller_path
    end

    def application_javascript_path

        path_segments = controller_path.split("/")
        cloud_module = path_segments.shift

        LC::Debug.msg path_segments, cloud_module

        if ["cloud_text", "cloud_house", "cloud_driver", "cloud_focus"].include?(cloud_module)
            return [cloud_module, [cloud_module, "app"].join("_")].join("/")
        end

        path_segments = controller_path.split("/")
        cloud_module = path_segments.shift
        [cloud_module, path_segments.push("app").compact().join("_")].join("/")
    end

end
