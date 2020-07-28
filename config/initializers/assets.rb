=begin

Lesli

Copyright (c) 2020, Lesli Technologies, S. A.

All the information provided by this website is protected by laws of Guatemala related 
to industrial property, intellectual property, copyright and relative international laws. 
Lesli Technologies, S. A. is the exclusive owner of all intellectual or industrial property
rights of the code, texts, trade mark, design, pictures and any other information.
Without the written permission of Lesli Technologies, S. A., any replication, modification,
transmission, publication is strictly forbidden.
For more information read the license file including with this software.

Lesli - Your Smart Business Assistant

Powered by https://www.lesli.tech
Building a better future, one line of code at a time.

@contact  <hello@lesli.tech>
@website  <https://lesli.tech>
@license  Propietary - all rights reserved.

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

=end


# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = "0.1.0"


# Add vendor libraries to assets
Rails.application.config.assets.paths << Rails.root.join("vendor")


# Public pages
Rails.application.config.assets.precompile += [ "lesli/templates/website.css" ]


# Themes
Rails.application.config.assets.precompile += [ "themes/blank.css" ]
Rails.application.config.assets.precompile += [ "themes/**/*.css" ]


# Lesli core assets

Rails.application.config.assets.precompile += [ "users.css", "users/*.js" ]
Rails.application.config.assets.precompile += [ "users/*.css", "users/*.js" ]
Rails.application.config.assets.precompile += [ "errors/*.css", "errors/*.js" ]
Rails.application.config.assets.precompile += [ "websites*.css", "websites/*.js" ]
Rails.application.config.assets.precompile += [ "accounts.css", "accounts/app.js" ]
Rails.application.config.assets.precompile += [ "profiles.css", "profiles/app.js" ]
Rails.application.config.assets.precompile += [ "dashboards.css", "dashboards/app.js" ]
Rails.application.config.assets.precompile += [ "settings.css", "settings/app.js" ]

Rails.application.config.assets.precompile += [ "i18n.js" ]


# dynamic include assets for engines
Rails.configuration.lesli_settings["engines"].each do |engine|
    Rails.application.config.assets.precompile += ["#{engine["code"]}/*.css", "#{engine["code"]}/*.js"]
    Rails.application.config.assets.precompile += ["#{engine["code"]}/*.jpg", "#{engine["code"]}/*.png",  "#{engine["code"]}/*.svg"]
end
