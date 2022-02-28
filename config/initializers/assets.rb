# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = "1.0"

# Add additional assets to the asset load path.
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in the app/assets
# folder are already added.
# Rails.application.config.assets.precompile += %w( admin.js admin.css )





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
Rails.application.config.assets.precompile += [ "role_descriptors.css", "role_descriptors/*.js" ]

# User profile management
Rails.application.config.assets.precompile += [ "profiles.css", "profiles/app.js" ]

# include users administration area and public assets for registration, password reset, etc.
Rails.application.config.assets.precompile += [ "users.css", "users/*.css", "users/*.js" ]

# 
Rails.application.config.assets.precompile += [ "cronos.css", "cronos/*.js" ]

# 
Rails.application.config.assets.precompile += [ "onboardings.css", "onboardings/*.css", "onboardings/*.js" ]


# Lesli core assets

Rails.application.config.assets.precompile += [ "users.css", "users/*.js" ]
Rails.application.config.assets.precompile += [ "user/**.css", "user/*.js" ]
Rails.application.config.assets.precompile += [ "abouts.css", "abouts/*.js" ]

Rails.application.config.assets.precompile += [ "errors/*.css", "errors/*.js" ]
Rails.application.config.assets.precompile += [ "websites*.css", "websites/*.js" ]

Rails.application.config.assets.precompile += [ "dashboards.css", "dashboards/app.js" ]
Rails.application.config.assets.precompile += [ "settings.css", "settings/app.js" ]
Rails.application.config.assets.precompile += [ "settings/*.css", "settings/*.js" ]

Rails.application.config.assets.precompile += [ "invites.css", "invites/**.js" ]
Rails.application.config.assets.precompile += [ "passes.css", "passes/**.js" ]
Rails.application.config.assets.precompile += [ "otps.css", "otps/**.js" ]

Rails.application.config.assets.precompile += [ "i18n.js" ]


# dynamic include assets for engines
Rails.configuration.lesli_settings["engines"].each do |engine|

    if [
        "cloud_text", "cloud_house", "cloud_babel",
        "cloud_audit", "cloud_realty"
    ].include?(engine[:code])
        Rails.application.config.assets.precompile += [
            "#{engine[:code]}/#{engine[:code]}_app.css", 
            "#{engine[:code]}/#{engine[:code]}_app.js"
        ]
    else 
        Rails.application.config.assets.precompile += ["#{engine[:code]}/*.css", "#{engine[:code]}/*.js"]
    end
    
    Rails.application.config.assets.precompile += ["#{engine[:code]}/*.jpg", "#{engine[:code]}/*.png",  "#{engine[:code]}/*.svg"]

end
