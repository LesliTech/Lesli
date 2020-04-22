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

LesliCloud - Your Smart Business Assistant

Powered by https://www.lesli.tech
Building a better future, one line of code at a time.

@license  Propietary - all rights reserved.
@version  0.1.0-alpha

// · ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~     ~·~
// · 

=end

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '0.1.0'

# Add additional assets to the asset load path.
#Rails.application.config.assets.paths << Rails.root.join('node_modules')
Rails.application.config.assets.paths << Rails.root.join('vendor')

# Precompile additional assets.

Rails.application.config.assets.precompile += %w(themes/blank.css)
Rails.application.config.assets.precompile += %w(themes/**/standard/*.css)

Rails.application.config.assets.precompile += %w( errors.css )
Rails.application.config.assets.precompile += %w( users/*.css )
Rails.application.config.assets.precompile += %w( websites.css )
Rails.application.config.assets.precompile += %w( accounts.css )
Rails.application.config.assets.precompile += %w( profiles.css )
Rails.application.config.assets.precompile += %w( dashboards.css )

Rails.application.config.assets.precompile += %w( users/*.js )
Rails.application.config.assets.precompile += %w( errors/*.js )
Rails.application.config.assets.precompile += %w( websites/*.js )
Rails.application.config.assets.precompile += %w( accounts/app.js )
Rails.application.config.assets.precompile += %w( profiles/app.js )
Rails.application.config.assets.precompile += %w( dashboards/app.js )
Rails.application.config.assets.precompile += %w( i18n.js )

if defined?(CloudHaus)
    Rails.application.config.assets.precompile += %w( cloud_haus/*.js )
    Rails.application.config.assets.precompile += %w( cloud_haus/*.css )
    Rails.application.config.assets.precompile += %w( cloud_haus/**/*.png cloud_haus/**/*.svg )
end

if defined?(CloudDriver)
    Rails.application.config.assets.precompile += %w( cloud_driver/*.js )
    Rails.application.config.assets.precompile += %w( cloud_driver/*.css )
end

if defined?(CloudFocus)
    Rails.application.config.assets.precompile += %w( cloud_focus/*.js )
    Rails.application.config.assets.precompile += %w( cloud_focus/*.css )
end

if defined?(CloudBabel)
    Rails.application.config.assets.precompile += %w( cloud_babel/*.js )
    Rails.application.config.assets.precompile += %w( cloud_babel/*.css )
end

if defined?(CloudBabel)
    Rails.application.config.assets.precompile += %w( cloud_bell/*.js )
    Rails.application.config.assets.precompile += %w( cloud_bell/*.css )
end
