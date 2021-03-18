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


# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = "0.1.0"

# Add vendor libraries to assets
Rails.application.config.assets.paths << Rails.root.join("vendor")

# Public pages
Rails.application.config.assets.precompile += [ "lesli/templates/public.css" ]

# Development
Rails.application.config.assets.precompile += [ "lesli/templates/development.css" ]

# Themes
Rails.application.config.assets.precompile += [ "themes/blank.css", "themes/**/*.css" ]

# Account management & settings
Rails.application.config.assets.precompile += [ "accounts.css", "account/*.css", "accounts/app.js", "account/*.js" ]

# Roles and privileges configuration
Rails.application.config.assets.precompile += [ "roles.css", "roles/*.js" ]

# User profile management
Rails.application.config.assets.precompile += [ "profiles.css", "profiles/app.js" ]

# include users administration area and public assets for registration, password reset, etc.
Rails.application.config.assets.precompile += [ "users.css", "users/*.css", "users/*.js" ]

# 
Rails.application.config.assets.precompile += [ "onboardings.css", "onboardings/*.css", "onboardings/*.js" ]




# Lesli core assets


Rails.application.config.assets.precompile += [ "users.css", "users/*.js" ]
Rails.application.config.assets.precompile += [ "abouts.css", "abouts/*.js" ]

Rails.application.config.assets.precompile += [ "errors/*.css", "errors/*.js" ]
Rails.application.config.assets.precompile += [ "websites*.css", "websites/*.js" ]

Rails.application.config.assets.precompile += [ "dashboards.css", "dashboards/app.js" ]
Rails.application.config.assets.precompile += [ "settings.css", "settings/app.js" ]
Rails.application.config.assets.precompile += [ "settings/*.css", "settings/*.js" ]

Rails.application.config.assets.precompile += [ "passes.css", "passes/**.js" ]
Rails.application.config.assets.precompile += [ "otps.css", "otps/**.js" ]

Rails.application.config.assets.precompile += [ "i18n.js" ]


# dynamic include assets for engines
Rails.configuration.lesli_settings["engines"].each do |engine|
    Rails.application.config.assets.precompile += ["#{engine[:code]}/*.css", "#{engine[:code]}/*.js"]
    Rails.application.config.assets.precompile += ["#{engine[:code]}/*.jpg", "#{engine[:code]}/*.png",  "#{engine[:code]}/*.svg"]
end
