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

Rails.application.config.assets.precompile += [ 

    # Templates
    "lesli/templates/application.css",
    "lesli/templates/public.css", 

    # Themes
    "themes/blank.css", 
    "themes/**/*.css",

    # Default dashboard
    "dashboards.css", "dashboards/app.js",

    # Account management & settings
    "accounts.css", "account/*.css", "accounts/app.js", "account/*.js",

    # Roles and privileges configuration
    "roles.css", "roles/*.js", "role_descriptors.css", "role_descriptors/*.js",

    # Users administration area and public assets for registration, password reset, etc.
    "users.css", "users/*.css", "user/**.css", "users/*.js", "user/*.js",

    # Alternative logins
    "passes.css", "passes/**.js", "otps.css", "otps/**.js",

    # Invitation request page
    "invites.css", "invites/**.js", 

    # General settings
    "settings.css", "settings/app.js",

    #
    "cronos.css", "cronos/*.js",

    # Onboarding pages
    "onboardings.css", "onboardings/*.css", "onboardings/*.js",

    # User profile 
    "profiles.css", "profiles/app.js",

    # About
    "abouts.css", "abouts/*.js",

    # Default public view
    "websites*.css", "websites/*.js",

    # Error pages for production
    "errors/*.css", "errors/*.js",

    # Translation methods
    "i18n.js"
]


# dynamic include assets for engines
Rails.configuration.lesli_settings["engines"].each do |engine|

    if [
        "cloud_text", "cloud_babel",
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
